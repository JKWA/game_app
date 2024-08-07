import { useState } from 'react'

import './App.css'
import Superheroes from './Superheroes';


function App() {

  return (
    <div className="App">
      <header className="App-header">
        <h1>Superheroes</h1>
      </header>
      <Superheroes />
    </div>
  )
}

export default App
