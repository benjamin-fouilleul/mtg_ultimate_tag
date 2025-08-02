const express = require("express");
const puppeteer = require("puppeteer");

const app = express();
const PORT = process.env.PORT || 4001;

app.get("/tags", async (req, res) => {
  const { set, number } = req.query;

  if (!set || !number) {
    return res.status(400).json({ error: "Missing 'set' or 'number' query param" });
  }

  const url = `https://tagger.scryfall.com/card/${set}/${number}`;

  try {
    const browser = await puppeteer.launch({
      headless: "new",
      args: ["--no-sandbox", "--disable-setuid-sandbox"]
    });

    const page = await browser.newPage();
    await page.goto(url, { waitUntil: "domcontentloaded", timeout: 7000 });

    await page.waitForSelector("h2", { timeout: 5000 });

    const tags = await page.evaluate(() => {
      const allTags = [];

      // Trouver le h2 "Cards"
      const h2s = Array.from(document.querySelectorAll("h2"));
      const cardHeader = h2s.find(h => h.textContent.trim() === "Card");

      if (!cardHeader) return [];

      // Parcours les éléments suivants
      let current = cardHeader.nextElementSibling;

      while (current) {
        if (["taggings", "tagging-ancestors"].some(cls => current.classList.contains(cls))) {
          const links = Array.from(current.querySelectorAll("a"));
          links.forEach(link => {
            const text = link.textContent.trim();
            if (text) allTags.push(text);
          });
        }

        // Stop si on arrive à un autre h2
        if (current.tagName === "H2") break;

        current = current.nextElementSibling;
      }

      // Nettoyage : trim + unique
      return [...new Set(allTags.map(tag => tag.trim()).filter(Boolean))];
    });

    await browser.close();

    res.json(tags);
  } catch (err) {
    console.error("Scraping failed:", err.message);
    res.status(500).json({ error: "Failed to fetch tags", details: err.message });
  }
});

app.listen(PORT, () => {
  console.log(`✅ Tagger service running at http://localhost:${PORT}`);
});
