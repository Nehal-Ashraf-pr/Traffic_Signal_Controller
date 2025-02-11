# **Traffic Signal Controller**  

## **Project Overview**  
This project implements a **traffic signal controller** for a **highway (hwy) and country road (cntry)** using a **finite state machine (FSM)**. The controller detects vehicles on the **country road (`x`)** and adjusts signals accordingly.  

## **Features**  
✅ **Finite State Machine (FSM) with 5 states** (`S0` to `S4`)  
✅ **Priority-based traffic management** (Highway gets priority unless a car is detected on the country road)  
✅ **Realistic signal transition delays (`Y2RDELAY`, `R2GDELAY`)**  
✅ **Fully synthesizable for FPGA deployment**  
✅ **Verilog testbench for functional verification**  

---

## **1️⃣ Module Details (`sig_control.v`)**  
### **Inputs & Outputs**  
| **Signal**  | **Direction** | **Description** |
|------------|--------------|----------------|
| `clk`      | **Input**   | Clock signal (Simulation: 10ns cycle) |
| `clr`      | **Input**   | Active HIGH reset |
| `x`        | **Input**   | Car detection on country road (`1` if car is present) |
| `hwy`      | **Output**  | 2-bit traffic signal for **highway** |
| `cntry`    | **Output**  | 2-bit traffic signal for **country road** |

### **Traffic Light Encoding**  
| **Light**  | **Binary Code** |
|------------|----------------|
| **RED**    | `00` |
| **YELLOW** | `01` |
| **GREEN**  | `10` |

---

## **2️⃣ Finite State Machine (FSM)**
| **State** | **Highway Light** | **Country Road Light** | **Transition Condition** |
|----------|------------------|----------------------|--------------------|
| `S0` (Default) | **GREEN**  | **RED**  | Car detected (`x=1`) → `S1` |
| `S1` | **YELLOW** | **RED**  | Delay (`Y2RDELAY`) → `S2` |
| `S2` | **RED**  | **RED**  | Delay (`R2GDELAY`) → `S3` |
| `S3` | **RED**  | **GREEN** | No car (`x=0`) → `S4` |
| `S4` | **RED**  | **YELLOW** | Delay (`Y2RDELAY`) → `S0` |

---

## **3️⃣ Simulation & Testbench (`stimulus.v`)**
### **Clock & Reset Handling**
- `clk` toggles every **5ns** (10ns cycle)
- `clr` is initially HIGH for 5 cycles, then LOW  
- `CAR_ON_CNTRY_RD` switches between `0` and `1` to trigger state transitions  

### **Expected Simulation Output**
```
       RED = 00 , YELLOW = 01 , GREEN = 10       

        5   Main Sig = 10 Country Sig = 00 Car on Country Road = 0
      200   Main Sig = 10 Country Sig = 00 Car on Country Road = 1
      205   Main Sig = 01 Country Sig = 00 Car on Country Road = 1
      245   Main Sig = 00 Country Sig = 00 Car on Country Road = 1
      275   Main Sig = 00 Country Sig = 10 Car on Country Road = 1
      300   Main Sig = 00 Country Sig = 10 Car on Country Road = 0
      305   Main Sig = 00 Country Sig = 01 Car on Country Road = 0
      345   Main Sig = 10 Country Sig = 00 Car on Country Road = 0
```
![image](https://github.com/user-attachments/assets/7cfb0153-19ba-43fd-8728-0cb299b4cde4)

### **Verification Checks**
✔ **Highway stays GREEN until a car arrives on the country road**  
✔ **Highway transitions through YELLOW before stopping**  
✔ **Country road gets GREEN only when highway is RED**  
✔ **Transitions occur with correct delays**  

---

## **4️⃣ How to Run the Simulation**
### **Using Xilinx ISE / ISim**
1. Open **Xilinx ISE**  
2. Add `sig_control.v` and `stimulus.v` to the project  
3. Set **`stimulus.v`** as the top module  
4. Run **Behavioral Simulation**  
5. Observe `hwy`, `cntry`, and `CAR_ON_CNTRY_RD` in the waveform  

---

## **5️⃣ Future Enhancements**
🔹 Extend timing delays for real-world traffic scenarios  
🔹 Implement **pedestrian crossings** and emergency vehicle override  
🔹 Add **traffic density-based control** using sensors  

---
