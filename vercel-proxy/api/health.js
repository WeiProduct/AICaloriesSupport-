export default function handler(req, res) {
  res.status(200).json({ 
    status: 'ok', 
    mode: 'proxy',
    timestamp: new Date().toISOString()
  });
}