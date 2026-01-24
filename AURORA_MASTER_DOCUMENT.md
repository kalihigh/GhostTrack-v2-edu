# AURORA‑CHAIN — DOCUMENTO UNIFICATO v1.0
### Whitepaper • Tokenomics • Protocollo PoI • Codice Base

---

# 1. WHITEPAPER

Aurora‑Chain è una blockchain progettata per portare nel mondo delle reti distribuite una logica civile, etica, verificabile, sostenibile.  
Non nasce per spremere energia o speculare, ma per coordinare, validare, proteggere e governare.

## Obiettivi
- Sicurezza civile  
- Sostenibilità  
- Trasparenza radicale  
- Partecipazione volontaria  

## Moneta nativa: AUR
Utility token per:
- staking  
- governance  
- ricompense  
- accesso ai moduli  

## Meccanismo di consenso: PoI
Proof‑of‑Integrity = PoS + PoR + PoV  
Basato su stake, reputazione e verifica incrociata.

## Ruoli
- Interlocutore di rete  
- Civil Defender  
- Archivista  

## Architettura
- Layer 1: Ledger & Consenso  
- Layer 2: Smart‑Modules  
- Layer 3: Interfacce Civili  

## Sicurezza
- SHA‑3 / BLAKE3  
- Ed25519  
- Anti‑Sybil  
- Audit automatici  

---

# 2. TOKENOMICS

## Supply
- Max supply: 1.000.000.000 AUR  
- Genesis supply: 200.000.000 AUR  

### Distribuzione iniziale
- Civil Defender: 60M  
- Ecosistema: 50M  
- Fondazione: 40M  
- Community: 30M  
- Team tecnico: 20M  

## Emissione
- 2% annuo della supply rimanente  

## Ricompense
- 70% Civil Defender  
- 20% Archivisti  
- 10% Governance  

## Fee
- Base: 0.001 AUR  
- Distribuzione: 50/30/20  

## Anti‑Whale
- Stake massimo: 2% supply circolante  
- Reputazione > Stake  
- Slashing proporzionale  

## Staking
- Minimo: 5.000 AUR  
- Reward: 4–7% annuo  

---

# 3. PROTOCOLLO PoI (Proof‑of‑Integrity)

## Componenti
- Stake  
- Reputazione  
- Verifica incrociata  

## Processo PoI
1. Proposta blocco  
2. Validazione primaria  
3. Verifica incrociata  
4. Quorum PoI  
5. Ricompense / Slashing  

## Selezione validatori
P = 0.4 × Stake + 0.6 × Reputazione  

## Slashing
Stake × Gravità_errore  

## Anti‑Sybil
- stake minimo  
- reputazione minima  
- verificatori casuali  
- audit automatici  

---

# 4. CODICE BASE (Python)

\`\`\`python
import hashlib
import time
import random

class Block:
    def __init__(self, index, previous_hash, transactions, proposer, reputation, stake):
        self.index = index
        self.timestamp = time.time()
        self.transactions = transactions
        self.previous_hash = previous_hash
        self.proposer = proposer
        self.reputation = reputation
        self.stake = stake
        self.hash = self.compute_hash()

    def compute_hash(self):
        block_string = f"{self.index}{self.timestamp}{self.transactions}{self.previous_hash}{self.proposer}{self.reputation}{self.stake}"
        return hashlib.sha256(block_string.encode()).hexdigest()


class AuroraChain:
    def __init__(self):
        self.chain = []
        self.pending_transactions = []
        self.nodes = {}
        self.create_genesis_block()

    def create_genesis_block(self):
        genesis = Block(0, "0", [], "GENESIS", 1, 0)
        self.chain.append(genesis)

    def register_node(self, node_id, stake, reputation):
        self.nodes[node_id] = {
            "stake": stake,
            "reputation": reputation
        }

    def select_proposer(self):
        weighted_nodes = []
        for node_id, data in self.nodes.items():
            weight = (data["stake"] * 0.4) + (data["reputation"] * 0.6)
            weighted_nodes.extend([node_id] * int(weight * 10))
        return random.choice(weighted_nodes)

    def validate_block(self, block):
        validators = random.sample(list(self.nodes.keys()), k=max(1, len(self.nodes)//2))
        approvals = 0

        for v in validators:
            if random.random() < self.nodes[v]["reputation"]:
                approvals += 1

        quorum = len(validators) * 0.67
        return approvals >= quorum

    def add_block(self, proposer):
        last_block = self.chain[-1]
        proposer_data = self.nodes[proposer]

        new_block = Block(
            index=len(self.chain),
            previous_hash=last_block.hash,
            transactions=self.pending_transactions,
            proposer=proposer,
            reputation=proposer_data["reputation"],
            stake=proposer_data["stake"]
        )

        if self.validate_block(new_block):
            self.chain.append(new_block)
            self.pending_transactions = []
            return True
        return False

    def add_transaction(self, tx):
        self.pending_transactions.append(tx)


if __name__ == "__main__":
    chain = AuroraChain()

    chain.register_node("NodeA", stake=5000, reputation=0.9)
    chain.register_node("NodeB", stake=3000, reputation=0.7)
    chain.register_node("NodeC", stake=2000, reputation=0.5)

    chain.add_transaction({"from": "Alice", "to": "Bob", "amount": 10})

    proposer = chain.select_proposer()
    print("Proposer:", proposer)

    if chain.add_block(proposer):
        print("Blocco aggiunto con successo")
    else:
        print("Validazione fallita")

    print("Lunghezza chain:", len(chain.chain))
\`\`\`

---

# 5. CONCLUSIONE

Aurora‑Chain è una blockchain civile, etica, sostenibile e governabile.  
Questo documento unificato rappresenta la base ufficiale del progetto.
