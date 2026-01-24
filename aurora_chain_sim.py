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

    def __repr__(self):
        return f"<Block {self.index} | proposer={self.proposer} | hash={self.hash[:10]}...>"


class AuroraChain:
    def __init__(self):
        self.chain = []
        self.pending_transactions = []
        self.nodes = {}
        self.create_genesis_block()

    def create_genesis_block(self):
        genesis = Block(0, "0", [], "GENESIS", 1.0, 0)
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
            if weight <= 0:
                continue
            weighted_nodes.extend([node_id] * int(weight * 10))
        if not weighted_nodes:
            raise ValueError("Nessun nodo eleggibile come proposer.")
        return random.choice(weighted_nodes)

    def validate_block(self, block):
        if len(self.nodes) == 0:
            return False

        validators_count = max(1, len(self.nodes) // 2)
        validators = random.sample(list(self.nodes.keys()), k=validators_count)
        approvals = 0

        for v in validators:
            rep = self.nodes[v]["reputation"]
            if random.random() < rep:
                approvals += 1

        quorum = len(validators) * 0.67
        return approvals >= quorum

    def add_block(self, proposer):
        last_block = self.chain[-1]
        proposer_data = self.nodes[proposer]

        new_block = Block(
            index=len(self.chain),
            previous_hash=last_block.hash,
            transactions=self.pending_transactions.copy(),
            proposer=proposer,
            reputation=proposer_data["reputation"],
            stake=proposer_data["stake"]
        )

        if self.validate_block(new_block):
            self.chain.append(new_block)
            self.pending_transactions = []
            return True, new_block
        return False, None

    def add_transaction(self, tx):
        self.pending_transactions.append(tx)


def demo():
    chain = AuroraChain()

    chain.register_node("NodeA", stake=5000, reputation=0.9)
    chain.register_node("NodeB", stake=3000, reputation=0.7)
    chain.register_node("NodeC", stake=2000, reputation=0.5)

    for i in range(5):
        chain.add_transaction({"from": f"Alice{i}", "to": f"Bob{i}", "amount": 10 + i})

        proposer = chain.select_proposer()
        print(f"\n[Round {i+1}] Proposer selezionato:", proposer)

        ok, block = chain.add_block(proposer)
        if ok:
            print("  → Blocco aggiunto:", block)
        else:
            print("  → Validazione fallita, blocco rifiutato")

    print("\nLunghezza finale della chain:", len(chain.chain))
    for b in chain.chain:
        print(b)


if __name__ == "__main__":
    demo()
