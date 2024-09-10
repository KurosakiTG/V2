#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <ctime>
#include <cstdlib>

void clearScreen() {
std::system("clear");
}

std::string getPublicIP() {
    std::string ip;
    std::system("curl -s ifconfig.me/ip > .ifconfig.txt");
    std::ifstream ifs(".ifconfig.txt");
    if (ifs.is_open()) {
        getline(ifs, ip);
        ifs.close();
    }
    std::system("rm -f .ifconfig.txt");
    return ip;
}

std::string getDomain() {
    std::string domain;
    std::ifstream ifs("/etc/xray/domain");
    if (ifs.is_open()) {
        getline(ifs, domain);
        ifs.close();
    }
    return domain;
}

void setIPLimit(const std::string& Login, int iplimit) {
    if (iplimit > 0) {
        std::ofstream ofs("/etc/funny/limit/ssh/ip/" + Login);
        if (ofs.is_open()) {
            ofs << iplimit;
            ofs.close();
        }
    }
}

void createUser(const std::string& Login, const std::string& Pass, const std::string& expi) {
    std::string cmd = "useradd -e " + expi + " -s /bin/false -M " + Login;
    system(cmd.c_str());

    cmd = "echo \"" + Pass + "\\n" + Pass + "\\n\" | passwd " + Login + " > /dev/null 2>&1";
    system(cmd.c_str());
}

int main() {
    std::string IP = getPublicIP();
    std::string domain = getDomain();

    clearScreen();

    std::string Login, Pass;
    std::cout << "Username : ";
    std::cin >> Login;
    std::cout << "Password : ";
    std::cin >> Pass;

    int masaaktif = 30;
    int iplimit = 2;

    clearScreen();

    if (iplimit > 0) {
        setIPLimit(Login, iplimit);
    }

    time_t now = time(0);
    tm* currentDate = localtime(&now);
    std::ostringstream os;
    os << (currentDate->tm_year + 1900) << "-" << (currentDate->tm_mon + 1) << "-" << currentDate->tm_mday;
    std::string hariini = os.str();
    os.str("");
    os << (currentDate->tm_year + 1900) << "-" << (currentDate->tm_mon + 1) << "-" << (currentDate->tm_mday + masaaktif);
    std::string expi = os.str();

    createUser(Login, Pass, expi);

    clearScreen();

    std::cout << "===============================" << std::endl;
    std::cout << " SSH ACCOUNT >< RERECHAN STORE " << std::endl;
    std::cout << "===============================" << std::endl;
    std::cout << "Username       : " << Login << std::endl;
    std::cout << "Password       : " << Pass << std::endl;
    std::cout << "Domain         : " << domain << std::endl;
    std::cout << "===============================" << std::endl;
    std::cout << "          Limit Data           " << std::endl;
    std::cout << "Limit Device   : 2" << std::endl;
    std::cout << "===============================" << std::endl;
    std::cout << "Domain         : " << domain << std::endl;
    std::cout << "Host           : " << IP << std::endl;
    std::cout << "OpenSSH        : 3303" << std::endl;
    std::cout << "Dropbear       : 111" << std::endl;
    std::cout << "SSL/TLS        : 443, 53, 2095" << std::endl;
    std::cout << "Websocket HTTP : 80, 2082" << std::endl;
    std::cout << "Websocket HTTPS: 443, 53, 2095" << std::endl;
    std::cout << "badvpn         : 7300" << std::endl;
    std::cout << "Masa Aktif     : " << expi << " / " << masaaktif << " Hari" << std::endl;
    std::cout << "===============================" << std::endl;
    std::cout << "PAYLOAD:" << std::endl;
    std::cout << "GET / HTTP/1.1[crlf]Host: " << domain << "[crlf]Connection: Keep-Alive[crlf]User-Agent: [ua][crlf]Upgrade: websocket[crlf][crlf]" << std::endl;
    std::cout << "===============================" << std::endl;

    return 0;
}