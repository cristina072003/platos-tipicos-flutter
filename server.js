const express = require('express');
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;
const JWT_SECRET = process.env.JWT_SECRET || 'your_secret_key';

// Middleware
app.use(cors());
app.use(express.json());

// Conexión a MongoDB
mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/platos_cochabamba', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

// Esquemas de MongoDB
const userSchema = new mongoose.Schema({
  nombre: String,
  email: { type: String, unique: true },
  password: String,
});

const platoSchema = new mongoose.Schema({
  nombre: String,
  descripcion: String,
  precio: Number,
  categoria: String,
  imagenUrl: String,
  lugares: [String],
});

const User = mongoose.model('User', userSchema);
const Plato = mongoose.model('Plato', platoSchema);

// Middleware de autenticación
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.sendStatus(401);
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.sendStatus(403);
    }
    req.user = user;
    next();
  });
};

// Rutas de autenticación
app.post('/api/auth/register', async (req, res) => {
  try {
    const { nombre, email, password } = req.body;
    
    // Verificar si el usuario ya existe
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: 'El usuario ya existe' });
    }
    
    // Hash de la contraseña
    const hashedPassword = await bcrypt.hash(password, 12);
    
    // Crear usuario
    const user = new User({
      nombre,
      email,
      password: hashedPassword,
    });
    
    await user.save();
    
    // Generar token
    const token = jwt.sign({ userId: user._id }, JWT_SECRET);
    
    res.status(201).json({
      user: {
        id: user._id,
        nombre: user.nombre,
        email: user.email,
        token,
      },
    });
  } catch (error) {
    res.status(500).json({ message: 'Error en el servidor' });
  }
});

app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    
    // Verificar si el usuario existe
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: 'Credenciales inválidas' });
    }
    
    // Verificar contraseña
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(400).json({ message: 'Credenciales inválidas' });
    }
    
    // Generar token
    const token = jwt.sign({ userId: user._id }, JWT_SECRET);
    
    res.json({
      user: {
        id: user._id,
        nombre: user.nombre,
        email: user.email,
        token,
      },
    });
  } catch (error) {
    res.status(500).json({ message: 'Error en el servidor' });
  }
});

// Rutas de platos
app.get('/api/platos', async (req, res) => {
  try {
    const { categoria } = req.query;
    let query = {};
    
    if (categoria && categoria !== 'Todos') {
      query = { categoria };
    }
    
    const platos = await Plato.find(query);
    res.json(platos);
  } catch (error) {
    res.status(500).json({ message: 'Error al obtener los platos' });
  }
});

app.get('/api/platos/:id', async (req, res) => {
  try {
    const plato = await Plato.findById(req.params.id);
    if (!plato) {
      return res.status(404).json({ message: 'Plato no encontrado' });
    }
    res.json(plato);
  } catch (error) {
    res.status(500).json({ message: 'Error al obtener el plato' });
  }
});

app.post('/api/platos', authenticateToken, async (req, res) => {
  try {
    const plato = new Plato(req.body);
    await plato.save();
    res.status(201).json(plato);
  } catch (error) {
    res.status(500).json({ message: 'Error al crear el plato' });
  }
});

app.put('/api/platos/:id', authenticateToken, async (req, res) => {
  try {
    const plato = await Plato.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!plato) {
      return res.status(404).json({ message: 'Plato no encontrado' });
    }
    res.json(plato);
  } catch (error) {
    res.status(500).json({ message: 'Error al actualizar el plato' });
  }
});

app.delete('/api/platos/:id', authenticateToken, async (req, res) => {
  try {
    const plato = await Plato.findByIdAndDelete(req.params.id);
    if (!plato) {
      return res.status(404).json({ message: 'Plato no encontrado' });
    }
    res.json({ message: 'Plato eliminado correctamente' });
  } catch (error) {
    res.status(500).json({ message: 'Error al eliminar el plato' });
  }
});

// Ruta para poblar la base de datos con datos iniciales
app.post('/api/populate', async (req, res) => {
  try {
    await Plato.deleteMany({});
    
    const platosIniciales = [
      {
        nombre: 'Sillpancho',
        descripcion: 'Plato consistente en un filete de carne empanizado y frito, servido sobre arroz y papas fritas, acompañado de ensalada de tomate, cebolla y locoto.',
        precio: 35.00,
        categoria: 'Almuerzo',
        imagenUrl: 'https://ejemplo.com/sillpancho.jpg',
        lugares: ['Casa de Campo', 'El Molino', 'La Cantonata']
      },
      {
        nombre: 'Pique Macho',
        descripcion: 'Plato que contiene trozos de carne de res y salchichas cortadas, papas fritas, cebolla, tomate, locoto y huevo duro, todo mezclado.',
        precio: 45.00,
        categoria: 'Almuerzo',
        imagenUrl: 'https://ejemplo.com/pique-macho.jpg',
        lugares: ['El Patio', 'La Estancia', 'Chuquiago']
      },
      {
        nombre: 'Anticucho',
        descripcion: 'Brochetas de corazón de res marinadas en ají y especias, asadas a la parrilla.',
        precio: 15.00,
        categoria: 'Cena',
        imagenUrl: 'https://ejemplo.com/anticucho.jpg',
        lugares: ['Puestos de la Cancha', 'Feria 25 de Mayo', 'Calle España']
      },
      {
        nombre: 'Humintas',
        descripcion: 'Tamales dulces o salados hechos con maíz molido, queso y pasas, envueltos en hojas de maíz y cocidos al vapor.',
        precio: 8.00,
        categoria: 'Desayuno',
        imagenUrl: 'https://ejemplo.com/humintas.jpg',
        lugares: ['Mercado de la Cancha', 'Panaderías tradicionales', 'Feria 25 de Mayo']
      },
      {
        nombre: 'Api con pastel',
        descripcion: 'Bebida caliente de maíz morado o amarillo, acompañada de un pastel frito relleno de queso.',
        precio: 12.00,
        categoria: 'Desayuno',
        imagenUrl: 'https://ejemplo.com/api-pastel.jpg',
        lugares: ['Puestos del mercado', 'Calle Perú', 'Plaza 14 de Septiembre']
      }
    ];
    
    await Plato.insertMany(platosIniciales);
    res.json({ message: 'Base de datos poblada correctamente' });
  } catch (error) {
    res.status(500).json({ message: 'Error al poblar la base de datos' });
  }
});

app.listen(PORT, () => {
  console.log(`Servidor corriendo en el puerto ${PORT}`);
});