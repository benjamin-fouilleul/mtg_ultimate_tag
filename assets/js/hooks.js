let Hooks = {}

Hooks.Persistence = {
  mounted() {
    const deck = this.el.dataset.deck
    const decks = this.el.dataset.decks
    const cards = this.el.dataset.cards

    try {
      localStorage.setItem("deck", deck)
      localStorage.setItem("decks", decks)
      localStorage.setItem("cards", cards)

      const parsedDeck = JSON.parse(deck)
      if (parsedDeck) {
        window.location.href = `/deck/${parsedDeck.id}`
      }
    } catch (e) {
      console.error("Could not persist deck:", e)
    }
  }
}

Hooks.Restore = {
  mounted() {
    const deck = localStorage.getItem("deck")
    const decks = localStorage.getItem("decks")
    const cards = localStorage.getItem("cards")

    if (decks && cards) {
      this.pushEvent("restore", {
        deck: JSON.parse(deck),
        decks: JSON.parse(decks),
        cards: JSON.parse(cards)
      })
    }
  }
}

export default Hooks
