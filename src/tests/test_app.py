import pytest
import json
# Importa a aplicação Flask do seu arquivo principal
from main import app 

@pytest.fixture
def client():
    """Configura um cliente de teste para a aplicação Flask."""
    # Configura o Flask para modo de teste
    app.config['TESTING'] = True
    # Cria uma instância de teste
    with app.test_client() as client:
        yield client # Retorna o cliente para ser usado nos testes

def test_conversao_sucesso_formulario(client):
    """Testa a conversão de Metro para Quilômetros (código '1') via formulário."""
    # Arrange (Organizar)
    dados = {
        'selectTemp': '1',  # Metro -> Quilômetros
        'valorRef': '5000' # 5000 metros
    }

    # Act (Executar)
    # Faz uma requisição POST simulada ao endpoint principal
    response = client.post('/', data=dados)
    
    # Assert (Verificar)
    # Verifica se a resposta foi bem-sucedida
    assert response.status_code == 200
    
    # Verifica se o resultado está na página (renderizado no HTML)
    # 5000 metros são 5 quilômetros
    assert b"5.0" in response.data 
    assert b"quil\xc3\xb4metros" in response.data # quilômetros em bytes UTF-8

def test_conversao_valor_invalido_formulario(client):
    """Testa o tratamento de exceção para valores não-numéricos no formulário."""
    # Arrange
    dados = {
        'selectTemp': '1',
        'valorRef': 'abc' # Valor inválido
    }

    # Act
    response = client.post('/', data=dados)
    
    # Assert
    assert response.status_code == 200
    assert b"Entrada inv\xc3\xa1lida" in response.data # Entrada inválida

def test_conversao_api_sucesso(client):
    """Testa a conversão de Milhas para Metro (código '4') via endpoint API."""
    # Arrange
    dados = {
        'conversion_type': '4', # Milhas -> Metro
        'value': 1
    }
    
    # Act
    # Faz uma requisição POST simulada ao endpoint /convert-api
    response = client.post('/convert-api', 
                           data=json.dumps(dados), 
                           content_type='application/json')
    
    # Assert
    assert response.status_code == 200
    data = json.loads(response.data.decode('utf-8'))
    
    # Verifica o resultado da API (1 milha = 1609.34 metros)
    assert data['success'] == True
    assert data['unit'] == 'metros'
    assert round(data['result'], 2) == 1609.34 

def test_conversao_api_dados_faltando(client):
    """Testa a validação de dados incompletos na API."""
    # Arrange
    dados = {
        'value': 100 # Falta 'conversion_type'
    }
    
    # Act
    response = client.post('/convert-api', 
                           data=json.dumps(dados), 
                           content_type='application/json')
    
    # Assert
    assert response.status_code == 400
    data = json.loads(response.data.decode('utf-8'))
    assert 'Dados inválidos' in data['error']