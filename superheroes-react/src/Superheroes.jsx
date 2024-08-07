import React, { useEffect, useState } from 'react';
import socket from './socket';

function Superheroes() {
  const [superheroes, setSuperheroes] = useState([]);

  const handleUpsert = (superhero) => {
    setSuperheroes(currentHeroes => {
      const index = currentHeroes.findIndex(hero => hero.id === superhero.id);
      if (index !== -1) {
        return currentHeroes.map(hero => hero.id === superhero.id ? superhero : hero);
      } else {
        return [...currentHeroes, superhero];
      }
    });
  };

  const handleAck = (channel, message_id) => {
    channel.push("message_ack", {
      message_id,
      status: "Received"
    })
  }

  useEffect(() => {
    const channel = socket.channel("superheroes:lobby", {});

    channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp); })
      .receive("error", resp => { console.log("Unable to join", resp); });

    channel.on("hydrate", payload => {
      const {superheroes, message_id} = payload

      setSuperheroes(superheroes);
      handleAck(channel, message_id);
    });

    channel.on("create", payload => {
      const { superhero, message_id } = payload;

      handleUpsert(superhero);
      handleAck(channel, message_id);
    });

    channel.on("update", payload => {
      const { superhero, message_id } = payload;

      handleUpsert(superhero);
      handleAck(channel, message_id);
    });

    channel.on("delete", payload => {
      const { superhero, message_id } = payload;

      setSuperheroes(currentHeroes => 
        currentHeroes.filter(hero => hero.id !== superhero.id)
      );
      handleAck(channel, message_id);
    });

    return () => {
      channel.leave();
    };
  }, []);

  return (
    <table>
      <thead>
        <tr>
          <th>Name</th>
          <th>Location</th>
          <th>Power</th>
        </tr>
      </thead>
      <tbody>
        {superheroes.map(hero => (
          <tr key={hero.id}>
            <td>{hero.name}</td>
            <td>{hero.location}</td>
            <td>{hero.power}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}

export default Superheroes;
