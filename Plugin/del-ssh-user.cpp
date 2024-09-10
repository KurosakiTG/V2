#include <iostream>
#include <string>
#include <cstdlib>

int main() {
    std::string user;
    system("clear");
    std::cout << "User: ";
    std::cin >> user;

    std::string os_name = "Ubuntu";
    if (os_name == "Ubuntu") {
        system(("killall -9 -u " + user + " > /dev/null 2>&1").c_str());
        system(("userdel -f -r " + user + " > /dev/null 2>&1").c_str());
    } else if (os_name == "Debian") {
        system(("killall -9 -u " + user + " > /dev/null 2>&1").c_str());
        system(("userdel -f -r " + user + " > /dev/null 2>&1").c_str());
    } else if (os_name == "CentOS") {
        system(("pkill -u " + user + " > /dev/null 2>&1").c_str());
        system(("userdel " + user + " > /dev/null 2>&1").c_str());
    }
    system("clear");
    return 0;
}
