import React, { useEffect, useState, useRef } from 'react';
import { Presence } from 'phoenix';
import socket from './socket';

const Notifications = () => {
  const channelRef = useRef(null);
  const [userName, setUserName] = useState('');
  const [notifications, setNotifications] = useState([]);
  const [presences, setPresences] = useState({});

  useEffect(() => {
    const channel = socket.channel("notifications:lobby");
    channelRef.current = channel;
    const presence = new Presence(channel);

    presence.onSync(() => {
      setPresences(presence.list());
    });

    channel.join()
      .receive("ok", () => {
        console.log("Joined notifications successfully");
      })
      .receive("error", (resp) => {
        console.error("Unable to join Notifications channel", resp);
      });

    channel.on("user_info", (payload) => {
      setUserName(payload.user_name);
    });

    channel.on("notification", (payload) => {
      setNotifications((notifications) => [...notifications, payload].slice(-5));
    });

    return () => {
      channel.leave();
    };
  }, []);

  const formatTimestamp = (timestamp) => {
    const date = new Date(parseInt(timestamp) * 1000);
    return date.toLocaleTimeString();
  };

  const handleButtonClick = (message) => () => {
    if (channelRef.current !== null) {
      channelRef.current.push(message, { body: `Message from ${userName}` });
    }
  };

  const handleDirectMessageClick = (recipient) => () => {
    if (channelRef.current !== null) {
      channelRef.current.push("notify_direct", { body: `Message to ${recipient} from ${userName}`, recipient });
    }
  };

  const renderPresences = (p) => 
    Object.values(p).flatMap(({ metas }) => 
      metas.map((meta) => (
        <tr key={meta.phx_ref}>
          <td>{meta.user_name === userName ? <strong>You</strong> : "Other"}</td>
          <td>{meta.user_name}</td>
          <td>
            <button onClick={handleDirectMessageClick(meta.user_name)}>
              Notify
            </button>
          </td>
        </tr>
      ))
    );

  const renderNotifications = (n) => 
    n.map(({body, timestamp}, index) => (
      <li key={index}>{formatTimestamp(timestamp)}: {body}</li>
    ));

  return (
    <div style={{ display: "flex", flexDirection: "column", flexWrap: "nowrap" }}>
      <div>
        <h2>Online</h2>
        <table>
          <tbody>
            {renderPresences(presences)}
          </tbody>
        </table>

        <div style={{ display: 'flex', justifyContent: "space-around", padding: "20px 0" }}>
          <button onClick={handleButtonClick("notify_others")}>Notify Others</button>
          <button onClick={handleButtonClick("notify_all")}>Notify All</button>
        </div>
      </div>

      <div>
        <h2>Notifications</h2>
        <ul>
          {renderNotifications(notifications)}
        </ul>
      </div>
    </div>
  );
};

export default Notifications;
