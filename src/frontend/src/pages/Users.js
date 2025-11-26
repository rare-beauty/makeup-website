import React, { useEffect, useState } from "react";
import axios from "axios";
//import usersImage from "../assets/users.jpg"; // Contact submissions header image

const Users = () => {
  const [users, setUsers] = useState([]);

  useEffect(() => {
    axios
      .get("/api/users")
      .then((res) => setUsers(res.data))
      .catch((err) => console.error("Error fetching users", err));
  }, []);

  return (
    <div style={styles.container}>
      <h2 style={styles.title}>👥 Users</h2>
      <div style={styles.grid}>
        {users.map((user, index) => (
          <div key={index} style={styles.card}>
            <h3 style={styles.name}>{user.name}</h3>
            <p style={styles.email}>{user.email}</p>
            <p style={styles.message}>
              👤 <i>{user.role}</i>
            </p>
          </div>
        ))}
      </div>
    </div>
  );
};

const styles = {
  container: {
    padding: "50px 30px",
    backgroundColor: "#0d0d0d",
    color: "#f0e6f6",
    fontFamily: "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif",
    minHeight: "100vh",
  },
  title: {
    fontSize: "2.5rem",
    marginBottom: 35,
    textAlign: "center",
    color: "#ff66b2",
    letterSpacing: 1,
    textShadow: "1px 1px 4px rgba(255, 102, 178, 0.5)",
  },
  grid: {
    display: "flex",
    flexWrap: "wrap",
    justifyContent: "center",
    gap: 30,
  },
  card: {
    background: "linear-gradient(135deg, #1a1a1a, #292929)",
    borderRadius: 16,
    padding: 25,
    width: 280,
    boxShadow: "0 4px 15px rgba(255, 105, 180, 0.1)",
    transition: "transform 0.2s ease, box-shadow 0.3s ease",
    border: "1px solid #333",
  },
  name: {
    fontSize: "20px",
    color: "#ffaad4",
    marginBottom: 6,
  },
  email: {
    fontSize: "14px",
    color: "#bbb",
    marginBottom: 12,
  },
  message: {
    fontSize: "15px",
    color: "#e9c8ff",
  },
};

export default Users;
