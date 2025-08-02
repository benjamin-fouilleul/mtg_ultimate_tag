let Hooks = {}

const storageKeys = ["deck", "decks", "cards", "tags"]

function getParsedFromStorage(keys) {
  return keys.reduce((acc, key) => {
    const raw = localStorage.getItem(key)
    if (raw) {
      try {
        acc[key] = JSON.parse(raw)
      } catch (e) {
        console.error(`Failed to parse localStorage key "${key}":`, e)
      }
    }
    return acc
  }, {})
}

function storeDataFromDataset(el, keys) {
  keys.forEach(key => {
    const value = el.dataset[key]
    if (value) localStorage.setItem(key, value)
  })
}

Hooks.Persistence = {
  mounted() {
    storeDataFromDataset(this.el, storageKeys)

    try {
      const parsedDeck = JSON.parse(this.el.dataset.deck)
      if (parsedDeck) {
        window.location.href = `/deck/${parsedDeck.id}`
      }
    } catch (e) {
      console.error("Could not parse deck from dataset:", e)
    }
  }
}

Hooks.Restore = {
  mounted() {
    const data = getParsedFromStorage(storageKeys)

    if (storageKeys.every(key => data[key])) {
      this.pushEvent("restore", data)
    }
  }
}

export default Hooks
