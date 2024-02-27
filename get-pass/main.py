import subprocess

# Obtendo os perfis de Wi-Fi no macOS usando o comando 'airport'
command = subprocess.check_output(['/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport', '-s']).decode('utf-8').split('\n')
networks = [line.split()[0] for line in command[1:] if len(line.split()) > 0]

# Iterando sobre cada rede para obter a senha (se disponível)
for network in networks:
    try:
        password_output = subprocess.check_output(['/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport', '-I', network]).decode('utf-8')
        password = [line.split(': ')[1].strip() for line in password_output.split('\n') if 'password' in line.lower()][0]
    except IndexError:
        password = "Senha não encontrada"
    except subprocess.CalledProcessError:
        password = "Erro ao acessar informações da rede"
    
    print("{:<30}|  {:<}".format(network, password))

input("")
