#!/data/data/com.termux/files/usr/bin/bash

echo "=== GhostTrack Civil Defender Wallet Setup — HighKali Edition ==="

# 1. Verifica repo
if [ ! -d ".git" ]; then
  echo "Errore: non sei dentro un repository Git."
  exit 1
fi

# 2. Verifica branch
BRANCH=$(git branch --show-current)
if [ "$BRANCH" != "patch-1" ]; then
  echo "Switch alla branch patch-1..."
  git checkout patch-1 || exit 1
fi

# 3. Crea directory
echo "Creazione directory src/wallet..."
mkdir -p src/wallet

# 4. Crea file wallet con codice completo
echo "Generazione civil-defender-wallet.js..."
cat > src/wallet/civil-defender-wallet.js << 'EOF'
// Civil Defender Wallet — GhostTrack-Chain (EDU) — Versione HighKali

const crypto = require('crypto');

// ------------------------- KeyManager -------------------------

class KeyManager {
  constructor() { this.keyPair = null; }

  generateKeyPair() {
    const { publicKey, privateKey } = crypto.generateKeyPairSync('ed25519');
    const kp = {
      publicKey: publicKey.export({ type: 'spki', format: 'der' }).toString('base64'),
      privateKey: privateKey.export({ type: 'pkcs8', format: 'der' }).toString('base64'),
    };
    this.keyPair = kp;
    return kp;
  }

  loadKeyPair(privateKeyBase64, publicKeyBase64) {
    this.keyPair = { publicKey: publicKeyBase64, privateKey: privateKeyBase64 };
    return this.keyPair;
  }

  getKeyPairOrThrow() {
    if (!this.keyPair) throw new Error('KeyPair non inizializzato');
    return this.keyPair;
  }

  getGhostId() {
    const { publicKey } = this.getKeyPairOrThrow();
    const hash = crypto.createHash('sha256').update(publicKey).digest('hex');
    return `GHOST-${hash}`;
  }

  sign(data) {
    const { privateKey } = this.getKeyPairOrThrow();
    const privateKeyObj = crypto.createPrivateKey({
      key: Buffer.from(privateKey, 'base64'),
      type: 'pkcs8',
      format: 'der',
    });
    return crypto.sign(null, Buffer.from(data, 'utf8'), privateKeyObj).toString('base64');
  }

  verify(data, signatureBase64) {
    const { publicKey } = this.getKeyPairOrThrow();
    const publicKeyObj = crypto.createPublicKey({
      key: Buffer.from(publicKey, 'base64'),
      type: 'spki',
      format: 'der',
    });
    return crypto.verify(
      null,
      Buffer.from(data, 'utf8'),
      publicKeyObj,
      Buffer.from(signatureBase64, 'base64')
    );
  }
}

// ------------------------- ContextGuardian -------------------------

class ContextGuardian {
  constructor() { this.storedFingerprints = []; }

  buildFingerprint(ctx) {
    const raw = `${ctx.deviceId}|${ctx.userAgent}|${ctx.locale}|${ctx.timeZone}`;
    return crypto.createHash('sha256').update(raw).digest('hex');
  }

  registerContext(ctx) {
    const fingerprint = this.buildFingerprint(ctx);
    const existing = this.storedFingerprints.find(f => f.fingerprint === fingerprint);
    if (existing) {
      existing.lastUsedAt = new Date();
      return existing;
    }
    const stored = {
      id: `CTX-${Date.now()}-${Math.random().toString(16).slice(2)}`,
      fingerprint,
      createdAt: new Date(),
      lastUsedAt: new Date(),
    };
    this.storedFingerprints.push(stored);
    return stored;
  }

  checkContext(ctx) {
    const fingerprint = this.buildFingerprint(ctx);
    const existing = this.storedFingerprints.find(f => f.fingerprint === fingerprint);
    if (!existing) return { fingerprint, recognized: false, score: 0 };
    existing.lastUsedAt = new Date();
    return { fingerprint, recognized: true, score: 1 };
  }
}

// ------------------------- TrackLedger -------------------------

class TrackLedger {
  constructor() {
    this.actions = [];
    this.entries = [];
  }

  registerAction(ghostId, type, payload) {
    const action = {
      id: `ACT-${Date.now()}-${Math.random().toString(16).slice(2)}`,
      ghostId,
      type,
      payload,
      createdAt: new Date(),
    };
    this.actions.push(action);
    return action;
  }

  rewardAction(action, rewardAmount) {
    const entry = {
      id: `LED-${Date.now()}-${Math.random().toString(16).slice(2)}`,
      actionId: action.id,
      ghostId: action.ghostId,
      type: action.type,
      timestamp: new Date(),
      rewardAmount,
      token: 'CIVSTABLE',
    };
    this.entries.push(entry);
    return entry;
  }

  getActionsByGhostId(ghostId) {
    return this.actions.filter(a => a.ghostId === ghostId);
  }

  getEntriesByGhostId(ghostId) {
    return this.entries.filter(e => e.ghostId === ghostId);
  }
}

// ------------------------- CivDefBank -------------------------

class CivDefBank {
  constructor() { this.balances = new Map(); }

  getOrInitBalance(ghostId) {
    const existing = this.balances.get(ghostId);
    if (existing) return existing;
    const created = {
      ghostId,
      token: 'CIVSTABLE',
      amount: 0,
      updatedAt: new Date(),
    };
    this.balances.set(ghostId, created);
    return created;
  }

  applyLedgerEntry(entry) {
    const balance = this.getOrInitBalance(entry.ghostId);
    balance.amount += entry.rewardAmount;
    balance.updatedAt = new Date();
    this.balances.set(entry.ghostId, balance);
    return balance;
  }

  getBalance(ghostId) {
    return this.getOrInitBalance(ghostId);
  }
}

// ------------------------- CivicStabilityEngine -------------------------

class CivicStabilityEngine {
  constructor() {
    this.totalActions = 0;
    this.defenseActions = 0;
  }

  registerActionForStability(action) {
    this.totalActions++;
    if (action.type === 'DEFENSE') this.defenseActions++;
  }

  getStabilityState() {
    if (this.totalActions === 0) return { stabilityIndex: 1, multiplier: 1 };
    const ratio = this.defenseActions / this.totalActions;
    const multiplier = 0.8 + ratio * 0.4;
    return { stabilityIndex: ratio, multiplier };
  }

  getStableValue(balance) {
    const { multiplier } = this.getStabilityState();
    return balance.amount * multiplier;
  }
}

// ------------------------- CivilDefenderWallet -------------------------

class CivilDefenderWallet {
  constructor(config) {
    this.keyManager = new KeyManager();
    this.contextGuardian = new ContextGuardian();
    this.ledger = new TrackLedger();
    this.bank = new CivDefBank();
    this.stabilityEngine = new CivicStabilityEngine();
    this.config = { minContextScoreToWrite: (config && config.minContextScoreToWrite) || 1 };
  }

  initNewIdentity() { this.keyManager.generateKeyPair(); }

  loadIdentity(privateKeyBase64, publicKeyBase64) {
    this.keyManager.loadKeyPair(privateKeyBase64, publicKeyBase64);
  }

  getGhostId() { return this.keyManager.getGhostId(); }

  registerTrustedContext(ctx) { return this.contextGuardian.registerContext(ctx); }

  ensureContextAllowed(ctx) {
    const check = this.contextGuardian.checkContext(ctx);
    if (!check.recognized || check.score < this.config.minContextScoreToWrite)
      throw new Error('Accesso negato: contesto non riconosciuto.');
  }

  registerCivilAction(ctx, type, payload, rewardAmount) {
    this.ensureContextAllowed(ctx);
    const ghostId = this.getGhostId();
    const action = this.ledger.registerAction(ghostId, type, payload);
    this.stabilityEngine.registerActionForStability(action);
    const entry = this.ledger.rewardAction(action, rewardAmount);
    const balance = this.bank.applyLedgerEntry(entry);
    return { action, entry, balance };
  }

  getBalance() { return this.bank.getBalance(this.getGhostId()); }

  getStableBalanceView() {
    const raw = this.getBalance();
    return { raw, stableValue: this.stabilityEngine.getStableValue(raw) };
  }

  signPayload(payload) { return this.keyManager.sign(JSON.stringify(payload)); }

  verifyPayload(payload, signature) {
    return this.keyManager.verify(JSON.stringify(payload), signature);
  }
}

module.exports = {
  CivilDefenderWallet,
  KeyManager,
  ContextGuardian,
  TrackLedger,
  CivDefBank,
  CivicStabilityEngine,
};
EOF

# 5. Crea README
echo "Generazione README del modulo..."
cat > src/wallet/README.md << 'EOF'
# Civil Defender Wallet — GhostTrack-Chain (EDU)

Modulo ufficiale per la gestione del token civile CIVSTABLE.
EOF

# 6. Git add
echo "Aggiunta file al commit..."
git add src/wallet/civil-defender-wallet.js
git add src/wallet/README.md

# 7. Commit
echo "Commit..."
git commit -m "Installazione Civil Defender Wallet + CIVSTABLE — HighKali Edition"

# 8. Push
echo "Push su patch-1..."
git push origin patch-1

echo "=== COMPLETATO ==="
echo "Il modulo Civil Defender Wallet è stato installato."
