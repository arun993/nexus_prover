# ⚡️Simple Guide to Run Nexus Prover CLI (Testnet 2)  ⚡️
![image](https://github.com/user-attachments/assets/fc040f56-bf85-47a1-b70c-fb7a76ca9664)
![image](https://github.com/user-attachments/assets/f7371393-3f3f-4550-a4cf-2a77b6da1ece)


### 👉Before we start here are Some Basic requirements : 
1. You need an Ubuntu VPS or Wsl (I recommand VPS)
2. There is no min. system requiremet but i recommand 4GB RAM and 4 cores CPU min. (The higher your speces the more points you will get per second)
3. Extract your Nexus Prover ID
4. (Optional) Also you can add Nexus Testnet and get $NEX faucet using this link : https://hub.nexus.xyz/

### 👉Open your terminal and follow these steps : 
1. Install Screen 
```
sudo apt update && sudo apt install screen -y && screen -S nexus
```
2. Run using one of the following commands :
```
[ -f "Nexus.sh" ] && rm -rf Nexus.sh; wget -q https://raw.githubusercontent.com/arun993/nexus_prover/refs/heads/main/Nexus.sh && chmod +x Nexus.sh && ./Nexus.sh

```
 OR           
```
[ -f "Nexus.sh" ] && rm -rf Nexus.sh; curl -sSf https://raw.githubusercontent.com/arun993/nexus_prover/refs/heads/main/Nexus.sh -o Nexus.sh && chmod +x Nexus.sh && ./Nexus.sh
```
**🚨It can take upto 15 Minutes to start till than grab a coffee!

3. After it starts Press ```Ctrl+A+D``` To exit and don't press ctrl+C ❌
4. You can check logs by connecting screen again ``` screen -r nexus``` 

:) Follow me on X for more guides : https://x.com/Arun__993  Thanks !!

