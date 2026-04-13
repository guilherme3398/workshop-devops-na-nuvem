import time
import socket
import logging
from flask import Flask, render_template, request, jsonify

# ================================
# MÉTRICAS PROMETHEUS (OFICIAL)
# ================================
from prometheus_client import make_wsgi_app, Counter, Histogram
from werkzeug.middleware.dispatcher import DispatcherMiddleware


app = Flask(
    __name__,
    static_url_path="/static",
    static_folder="static",
    template_folder="templates"
)

# ==========================================
# 1. Definição das métricas Prometheus
# ==========================================

# Contador de requisições
REQUEST_COUNT = Counter(
    "http_requests_total",
    "Contagem total de requisições HTTP",
    ["method", "endpoint", "status"]
)

# Histograma de latência
REQUEST_LATENCY = Histogram(
    "http_request_duration_seconds",
    "Latência das requisições HTTP",
    ["method", "endpoint"]
)


# ==========================================
# 2. Middleware de métricas
# ==========================================

@app.before_request
def before_request_func():
    """
    Inicia o timer do Prometheus.
    Usa .time() que retorna um objeto Timer, 
    e será finalizado no after_request.
    """
    request.start_time = REQUEST_LATENCY.labels(
        request.method,
        request.path
    ).time()


@app.after_request
def after_request_func(response):
    """
    Finaliza o timer e registra contagem de requisições.
    """
    if hasattr(request, "start_time"):
        try:
            request.start_time.stop()
        except Exception as e:
            app.logger.error(f"Erro ao registrar latência: {e}")

    REQUEST_COUNT.labels(
        request.method,
        request.path,
        response.status_code
    ).inc()

    return response


# ==========================================
# 3. Rotas da aplicação
# ==========================================

@app.route("/", methods=["GET", "POST"])
def index():
    hostname = "Desconhecido"
    ip_address = "N/A"

    # tratamento para evitar falha 500 em pod sem DNS reverso
    try:
        hostname = socket.gethostname()
        ip_address = socket.gethostbyname(hostname)
    except Exception as e:
        app.logger.error(f"Erro ao obter hostname/IP no Pod: {e}")

    if request.method == "GET":
        return render_template("index.html", hostname=hostname, ip_address=ip_address)

    # POST → conversão
    selecao = request.form.get("selectTemp")
    valor = request.form.get("valorRef")

    try:
        valor = float(valor)
    except:
        return render_template(
            "index.html",
            conteudo={"unidade": "inválido", "valor": "Entrada inválida"},
            hostname=hostname,
            ip_address=ip_address
        )

    conversoes = {
        '1': {'fator': 1/1000, 'unidade': 'quilômetros'},
        '2': {'fator': 1000, 'unidade': 'metros'},
        '3': {'fator': 1/1609.34, 'unidade': 'milhas'},
        '4': {'fator': 1609.34, 'unidade': 'metros'},
        '5': {'fator': 3.28084, 'unidade': 'pés'},
        '6': {'fator': 1/3.28084, 'unidade': 'metros'},
        '7': {'fator': 1/100, 'unidade': 'metros'},
        '8': {'fator': 100, 'unidade': 'centímetros'},
        '9': {'fator': 2.54, 'unidade': 'centímetros'},
        '10': {'fator': 1/2.54, 'unidade': 'polegadas'},
        '11': {'fator': 0.9144, 'unidade': 'metros'},
        '12': {'fator': 1/0.9144, 'unidade': 'jardas'},
    }

    if selecao in conversoes:
        conv = conversoes[selecao]
        resultado = valor * conv["fator"]
        unidade = conv["unidade"]
    else:
        resultado = "Inválido"
        unidade = ""

    return render_template(
        "index.html",
        conteudo={"unidade": unidade, "valor": resultado},
        hostname=hostname,
        ip_address=ip_address
    )


@app.route("/convert-api", methods=["POST"])
def convert_api():
    try:
        data = request.get_json()
        selecao = data.get("conversion_type")
        valor = data.get("value")

        if not selecao or valor is None:
            return jsonify({"error": "Dados inválidos"}), 400

        try:
            valor = float(valor)
        except:
            return jsonify({"error": "Valor deve ser numérico"}), 400

        conversoes = {
            '1': {'fator': 1/1000, 'unidade': 'quilômetros'},
            '2': {'fator': 1000, 'unidade': 'metros'},
            '3': {'fator': 1/1609.34, 'unidade': 'milhas'},
            '4': {'fator': 1609.34, 'unidade': 'metros'},
            '5': {'fator': 3.28084, 'unidade': 'pés'},
            '6': {'fator': 1/3.28084, 'unidade': 'metros'},
            '7': {'fator': 1/100, 'unidade': 'metros'},
            '8': {'fator': 100, 'unidade': 'centímetros'},
            '9': {'fator': 2.54, 'unidade': 'centímetros'},
            '10': {'fator': 1/2.54, 'unidade': 'polegadas'},
            '11': {'fator': 0.9144, 'unidade': 'metros'},
            '12': {'fator': 1/0.9144, 'unidade': 'jardas'},
        }

        if selecao not in conversoes:
            return jsonify({"error": "Tipo inválido"}), 400

        conv = conversoes[selecao]
        resultado = valor * conv["fator"]

        return jsonify({
            "success": True,
            "result": resultado,
            "unit": conv["unidade"],
            "original_value": valor
        })

    except Exception as e:
        app.logger.error(f"Erro interno na API: {e}")
        return jsonify({"error": "Erro interno"}), 500


# ==========================================
# 4. Expor métricas via /metrics
# Gunicorn usa: main:application
# ==========================================

metrics_app = make_wsgi_app()

application = DispatcherMiddleware(app, {
    "/metrics": metrics_app
})

# ==========================================
# 5. Execução local (sem Gunicorn)
# ==========================================

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
