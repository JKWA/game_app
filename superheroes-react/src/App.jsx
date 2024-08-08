import './App.css'
import Superheroes from './Superheroes';
import Notification from './Notifications';

function App() {

  return (
    <div className="App">
      
      <header className="App-header">
        <h1>Superheroes</h1>
      </header>
      <div style={{display: 'flex', flexDirection: "row", flexWrap:"nowrap", gap: '40px' }}>
        <Notification />
        <Superheroes />
      </div>
    </div>
  )
}

export default App
