const express = require('express');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());
// In-memory "database" of partner SACCO members
let members = [
  { id: 1, name: 'Mary Wanjiru', email: 'mary.wanjiru@unitysacco.co.ke', phone: '0712345678', sacco: 'Unity SACCO' },
  { id: 2, name: 'John Kamau', email: 'john.kamau@stimasacco.co.ke', phone: '0723456789', sacco: 'Stima SACCO' },
  { id: 3, name: 'Grace Achieng', email: 'grace.achieng@mwalimusacco.co.ke', phone: '0734567890', sacco: 'Mwalimu SACCO' },
  { id: 4, name: 'Peter Otieno', email: 'peter.otieno@harambeesacco.co.ke', phone: '0745678901', sacco: 'Harambee SACCO' },
  { id: 5, name: 'Lucy Njeri', email: 'lucy.njeri@kenyapolicesacco.co.ke', phone: '0756789012', sacco: 'Kenya Police SACCO' },
];
let nextId = 6;

const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.json({ message: 'SACCO Partner API is running' });
});
// GET /api/members - retrieve all partner members
app.get('/api/members', (req, res) => {
  res.json(members);
});
// GET /api/members/:id - retrieve a single member by their ID
app.get('/api/members/:id', (req, res) => {
  const member = members.find((m) => m.id === parseInt(req.params.id));
  if (!member) return res.status(404).json({ error: 'Member not found' });
  res.json(member);
});
// POST /api/members - add a new partner member
app.post('/api/members', (req, res) => {
  const { name, email, phone, sacco } = req.body;
  if (!name || !email || !phone || !sacco) {
    return res.status(400).json({ error: 'name, email, phone and sacco are required' });
  }
  const newMember = { id: nextId++, name, email, phone, sacco };
  members.push(newMember);
  res.status(201).json(newMember);
});
// PUT /api/members/:id - update an existing member
app.put('/api/members/:id', (req, res) => {
  const member = members.find((m) => m.id === parseInt(req.params.id));
  if (!member) return res.status(404).json({ error: 'Member not found' });

  const { name, email, phone, sacco } = req.body;
  if (name) member.name = name;
  if (email) member.email = email;
  if (phone) member.phone = phone;
  if (sacco) member.sacco = sacco;

  res.json(member);
});
// DELETE /api/members/:id - remove a member
app.delete('/api/members/:id', (req, res) => {
  const index = members.findIndex((m) => m.id === parseInt(req.params.id));
  if (index === -1) return res.status(404).json({ error: 'Member not found' });

  members.splice(index, 1);
  res.status(204).send();
});

app.listen(PORT, () => {
  console.log(`SACCO backend running on port ${PORT}`);
});