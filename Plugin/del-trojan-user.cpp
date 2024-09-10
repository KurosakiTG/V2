#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>

using namespace std;

int main() {
    string user;
    system("clear");
    cout << "User: ";
    cin >> user;

    ifstream configFile("/etc/xray/config.json");
    string line;
    vector<string> lines;
    bool inBlock = false;

    while (getline(configFile, line)) {
        if (!inBlock && line.find("### " + user) != string::npos) {
            inBlock = true;
            continue;
        }

        if (inBlock && line.find("},{") != string::npos) {
            inBlock = false;
            continue;
        }

        if (!inBlock) {
            lines.push_back(line);
        }
    }

    configFile.close();

    ofstream outFile("/etc/xray/config.json");
    for (const auto& l : lines) {
        outFile << l << endl;
    }
    outFile.close();

    system("systemctl restart xray > /dev/null 2>&1");
    system("clear");

    return 0;
}
