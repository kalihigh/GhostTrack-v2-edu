# Aurora‑Chain — Protocollo di Consenso PoI (Proof‑of‑Integrity)
### Versione 0.1

## 1. Introduzione
Il Proof‑of‑Integrity (PoI) è il meccanismo di consenso nativo di Aurora‑Chain.  
È progettato per garantire sicurezza, sostenibilità e governance civile senza ricorrere a mining energivoro o potenza computazionale bruta.

PoI combina tre elementi:
- **PoS — Proof‑of‑Stake**
- **PoR — Proof‑of‑Reputation**
- **PoV — Proof‑of‑Verification**

L’obiettivo è creare un sistema meritocratico, resistente agli attacchi e trasparente.

---

## 2. Componenti del PoI

### 2.1 Stake
Ogni nodo Civil Defender blocca una quantità minima di AUR per partecipare al consenso.

- Stake minimo: **5.000 AUR**
- Stake massimo: **2% della supply circolante**
- Lo stake funge da garanzia contro comportamenti malevoli.

### 2.2 Reputazione
Ogni nodo possiede un **Reputation Score**, che cresce o diminuisce in base a:

- validazioni corrette  
- uptime  
- partecipazione ai quorum  
- assenza di comportamenti sospetti  
- audit automatici  

La reputazione pesa più dello stake nella selezione dei validatori.

### 2.3 Verifica Incrociata
Ogni blocco proposto viene verificato da:

- un gruppo di Civil Defender selezionati  
- un sottoinsieme casuale di nodi (verificatori PoV)

Questo impedisce collusioni e attacchi coordinati.

---

## 3. Processo di Validazione PoI

### 3.1 Fasi del processo

**Fase 1 — Proposta del blocco**  
Un nodo con reputazione sufficiente propone un nuovo blocco.

**Fase 2 — Validazione primaria (PoS + PoR)**  
Un gruppo di Civil Defender controlla:

- firme  
- transazioni  
- timestamp  
- integrità del Merkle root  
- coerenza con il ledger  

**Fase 3 — Verifica incrociata (PoV)**  
Un set casuale di nodi verifica il lavoro dei validatori.

**Fase 4 — Quorum di Integrità**  
Il blocco è accettato solo se:

\[
Validazioni\_Positive \geq Soglia\_PoI
\]

La soglia è governabile on‑chain (default: 67%).

**Fase 5 — Ricompense e penalità**  
- Validatori corretti → micro‑ricompense AUR  
- Verificatori corretti → micro‑ricompense AUR  
- Nodi malevoli → perdita reputazione + slashing stake  

---

## 4. Selezione dei Validatori

La selezione dei validatori avviene tramite un algoritmo ibrido:

\[
P(nodo) = 0.4 \times Stake + 0.6 \times Reputazione
\]

Questo garantisce che:

- lo stake conta  
- ma la reputazione conta di più  
- nessun nodo può dominare la rete solo con capitale

---

## 5. Slashing

Il sistema applica penalità proporzionali allo stake e alla gravità dell’errore.

### Tipi di slashing:

- **Soft Slashing**  
  - downtime  
  - mancata partecipazione  
  - errori non malevoli  

- **Hard Slashing**  
  - doppia firma  
  - blocchi fraudolenti  
  - tentativi di attacco  

### Formula:

\[
Slashing = Stake \times Gravità\_Errore
\]

---

## 6. Anti‑Sybil

PoI integra protezioni native:

- stake minimo  
- reputazione minima  
- verificatori casuali  
- audit automatici  
- limite allo stake massimo  

Questo rende gli attacchi Sybil estremamente costosi.

---

## 7. Audit Automatici

Ogni nodo viene valutato periodicamente:

- uptime  
- coerenza ledger  
- comportamento di rete  
- partecipazione ai quorum  

Gli audit aggiornano la reputazione in tempo reale.

---

## 8. Vantaggi del PoI

### **1. Sostenibile**
Zero mining energivoro.

### **2. Meritocratico**
La reputazione pesa più del capitale.

### **3. Sicuro**
Verifica incrociata + slashing + audit.

### **4. Trasparente**
Ogni validazione è verificabile.

### **5. Civile**
I nodi sono “difensori”, non “minatori”.

---

## 9. Conclusione

Il Proof‑of‑Integrity è un consenso progettato per una blockchain etica, sostenibile e governabile.  
Non premia la forza bruta, ma la correttezza, la reputazione e la partecipazione civile.

