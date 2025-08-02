echo "🚀 Lancement du scraper Node..."
lsof -ti :4001 | xargs kill -9
(cd node_scraper && npm install && node index.js) &

echo "🧙‍♂️ Lancement de l'app Phoenix..."
(mix deps.get && mix phx.server)