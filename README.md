# RF, Analog & Semiconductor Device Engineering Portfolio

A collection of three hardware design, full-wave 3D electromagnetic simulation, and semiconductor TCAD physics projects completed at the **Department of Electronics Engineering, German University in Cairo (GUC)**.

---

## 1. [`01_5GHz_Chebyshev_Microstrip_LPF_CST/`](01_5GHz_Chebyshev_Microstrip_LPF_CST/)
### **7th-Order 5.0 GHz Equal-Ripple Chebyshev Microstrip Low-Pass Filter (CST Microwave Studio)**

* **Analytical Synthesis (Richards' Transformation & Kuroda's Identities):** Synthesized a $N=7$ Chebyshev prototype ($0.5\text{ dB}$ passband ripple, $f_c = 5.0\text{ GHz}$, $Z_0 = 50\,\Omega$), mapped lumped elements to commensurate $\lambda_g/8$ ($\theta = 45^\circ$) transmission lines via Richards' transformation, and introduced Unit Elements (UEs) with **Kuroda's identities** to convert un-manufacturable series short-circuit stubs into planar open-circuit shunt stubs ($Z_{\text{Stub1,7}} = 178.77\,\Omega$, $Z_{\text{UE1,6}} = 69.41\,\Omega$, $Z_{\text{Stub2,6}} = 39.40\,\Omega$, $Z_{\text{UE2,5}} = 136.65\,\Omega$, $Z_{\text{Stub3,5}} = 37.98\,\Omega$, $Z_{\text{UE3,4}} = 162.70\,\Omega$, $Z_{\text{Stub4}} = 37.19\,\Omega$).
* **3D EM Full-Wave Optimization:** Modeled the planar layout on a $2.0\text{ mm}$ FR4 dielectric substrate in **CST Microwave Studio** and executed Trust Region Framework parametric optimization across 7 independent stub/UE lengths to compensate for open-end fringing capacitance ($\Delta l$) and 3D cross-junction parasitics (recovering the downward-shifted $3.5\text{ GHz}$ cutoff to the exact **$5.0\text{ GHz}$** target with $S_{11} < -15\text{ dB}$ across $0\text{–}4.5\text{ GHz}$ and $S_{21} < -40\text{ dB}$ stopband rejection).
* **Report & Figures:** [`5GHz_7th_Order_Microstrip_LPF_Report.pdf`](01_5GHz_Chebyshev_Microstrip_LPF_CST/5GHz_7th_Order_Microstrip_LPF_Report.pdf) | [`figures/`](01_5GHz_Chebyshev_Microstrip_LPF_CST/figures/)

---

## 2. [`02_InGaP_QW_Laser_Diode_Silvaco_TCAD/`](02_InGaP_QW_Laser_Diode_Silvaco_TCAD/)
### **Semiconductor Laser Diode TCAD Modeling & Confinement Optimization (Silvaco Atlas & MATLAB)**

* **Quantum Well (QW) vs. Bulk Heterostructure Physics:** Simulated a $10\text{ nm}$ $\text{InGaP}$ ($E_g \approx 1.92\text{ eV}$) Quantum Well active layer sandwiched between $\text{InAlGaP}$ cladding layers using **Silvaco Atlas (`qwell` Schrödinger-Poisson solver, `gainmod=5`)**, demonstrating a **$20\times$ increase in peak local optical gain** ($1160\text{ cm}^{-1}$ vs. $55\text{ cm}^{-1}$ in bulk $\text{InGaAsP}$) and a **$100\times$ boost in pre-threshold radiative recombination rate** ($2.4 \times 10^{26}\text{ cm}^{-3}\text{s}^{-1}$).
* **Separate Confinement Heterostructure (SCH) & Buried Heterostructure (BH) Optimization:** Engineered stepped waveguide refractive-index profiles to maximize the optical confinement factor $\Gamma$ (halving the required threshold material gain $g_{\text{th}}$ from $1160\text{ cm}^{-1}$ to $580\text{ cm}^{-1}$) and contrasted planar stripe geometry against Buried Heterostructure (BH) lateral confinement—achieving a **40% reduction in lasing threshold current ($I_{\text{th}}$ lowered from $5\text{ mA}$ to $3\text{ mA}$)** with single-mode spectral narrowing ($10^5\times$ photon density surge at resonance).
* **Quantum Tunneling Transfer Matrix Method (`quantum_well_tmm_transmission.m`):** MATLAB implementation of the Transfer Matrix Method (TMM) solving the 1D time-independent Schrödinger equation across spatially varying heterostructure potentials ($0.01\text{–}3.0\text{ eV}$).
* **Report & Scripts:** [`InGaP_QW_SCH_BH_Laser_Diode_TCAD_Report.pdf`](02_InGaP_QW_Laser_Diode_Silvaco_TCAD/InGaP_QW_SCH_BH_Laser_Diode_TCAD_Report.pdf) | [`quantum_well_tmm_transmission.m`](02_InGaP_QW_Laser_Diode_Silvaco_TCAD/quantum_well_tmm_transmission.m) | [`figures/`](02_InGaP_QW_Laser_Diode_Silvaco_TCAD/figures/)

---

## 3. [`03_ClassAB_BJT_Audio_Power_Amplifier/`](03_ClassAB_BJT_Audio_Power_Amplifier/)
### **Four-Stage Discrete BJT Class-AB Audio Power Amplifier (KiCad, Proteus & Hardware Breadboard)**

* **4-Stage Cascaded Architecture:** Designed, simulated, and physically constructed a single-supply ($12\text{ V}$) discrete BJT audio amplifier driving an $8\,\Omega$ low-impedance speaker load:
  1. **Common-Emitter Voltage Gain Stage (`2N3904`):** Biased at $I_{C1} = 2.225\text{ mA}$, $V_{CE} = 5.97\text{ V}$ with partial emitter bypass for $-20.26\text{ V/V}$ unloaded mid-band gain.
  2. **Common-Collector Emitter-Follower Buffer (`2N3904`):** High-current buffer ($I_{C2} = 28.0\text{ mA}$, $R_{\text{out}} = 15.4\,\Omega$) isolating the high-impedance CE collector.
  3. **Adjustable $V_{BE}$ Multiplier Biasing Network:** Maintains a constant $1.86\text{ V}$ potential drop across the complimentary power bases ($I_Q = 33.1\text{ mA}$), completely eliminating zero-crossing crossover distortion.
  4. **Complementary Push-Pull Class-AB Output Stage (`TIP35C` NPN / `TIP36C` PNP):** Centers the quiescent output node at exactly $6.00\text{ V}$ ($V_{CC}/2$) and transforms the driving impedance down to $< 1\,\Omega$.
* **Theory, SPICE & Hardware Correlation:** Matched theoretical small-signal hybrid-$\pi$ derivations, KiCad/Proteus SPICE transient simulations, and physical oscilloscope measurements at **$-17.0\text{ V/V}$ loaded voltage gain** across the $8\,\Omega$ loudspeaker.
* **Report & Figures:** [`ClassAB_BJT_Audio_Amplifier_Report.pdf`](03_ClassAB_BJT_Audio_Power_Amplifier/ClassAB_BJT_Audio_Amplifier_Report.pdf) | [`2N3904-APCT-ND.lib`](03_ClassAB_BJT_Audio_Power_Amplifier/2N3904-APCT-ND.lib) | [`figures/`](03_ClassAB_BJT_Audio_Power_Amplifier/figures/)
