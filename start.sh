echo "🚀 Lancement du scraper Node..."
(cd node_scraper && npm install && node index.js) &

echo "🧙‍♂️ Lancement de l'app Phoenix..."
(mix deps.get && mix phx.server)