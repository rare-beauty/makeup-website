import React, { useEffect, useState } from "react";
import axios from "axios";
import ordersImage from "../assets/orders.png"; // 📸 Make sure this image exists

const Orders = () => {
  const [orders, setOrders] = useState([]);
  const [filteredOrders, setFilteredOrders] = useState([]);
  const [statusFilter, setStatusFilter] = useState("all");
  const [search, setSearch] = useState("");
  const [adminView, setAdminView] = useState("guest");
  const [currentPage, setCurrentPage] = useState(1);
  const ordersPerPage = 4;

  useEffect(() => {
    fetchOrders();
  }, []);

  useEffect(() => {
    filterOrders();
  }, [orders, search, statusFilter]);

  const fetchOrders = async () => {
    try {
      const res = await axios.get("http://localhost:4004/orders");
      setOrders(res.data);
    } catch (err) {
      console.error("Error fetching orders", err);
    }
  };

  const filterOrders = () => {
    let data = [...orders];
    if (search.trim()) {
      data = data.filter((o) =>
        o.productName?.toLowerCase().includes(search.toLowerCase())
      );
    }
    if (statusFilter !== "all") {
      data = data.filter((o) => o.status === statusFilter);
    }
    setFilteredOrders(data);
    setCurrentPage(1);
  };

  const handleDelete = async (orderId) => {
    if (!window.confirm("Are you sure you want to delete this order?")) return;
    try {
      await axios.delete(`http://localhost:4004/orders/${orderId}`);
      alert("Order deleted");
      setOrders((prev) => prev.filter((o) => o._id !== orderId));
    } catch (err) {
      alert("Failed to delete order.");
    }
  };

  const handleStatusChange = async (orderId, newStatus) => {
    try {
      await axios.patch(`http://localhost:4004/orders/${orderId}`, {
        status: newStatus,
      });
      fetchOrders();
    } catch {
      alert("Failed to update status.");
    }
  };

  const start = (currentPage - 1) * ordersPerPage;
  const paginated = filteredOrders.slice(start, start + ordersPerPage);
  const totalPages = Math.ceil(filteredOrders.length / ordersPerPage);

  return (
    <div style={styles.container}>
      <img src={ordersImage} alt="Orders" style={styles.banner} />
      <h2 style={styles.heading}>🛒 Orders</h2>

      {/* Filter Panel */}
      <div style={styles.filters}>
        <select value={statusFilter} onChange={(e) => setStatusFilter(e.target.value)} style={styles.select}>
          <option value="all">All Status</option>
          <option value="pending">Pending</option>
          <option value="processing">Processing</option>
          <option value="completed">Completed</option>
        </select>

        <input
          type="text"
          placeholder="Search by product name"
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          style={styles.input}
        />

        <select value={adminView} onChange={(e) => setAdminView(e.target.value)} style={styles.select}>
          <option value="guest">Guest</option>
          <option value="admin">Admin</option>
        </select>
      </div>

      {/* Orders List */}
      {paginated.map((o, i) => (
        <div key={i} style={styles.card}>
          {o.productImageUrl && (
            <img
              src={`http://localhost:4003${o.productImageUrl}`}
              alt={o.productName}
              style={styles.image}
            />
          )}
          <p><strong>Product:</strong> {o.productName}</p>
          <p><strong>Total:</strong> ${o.total}</p>
          <p>
            <strong>Status:</strong>{" "}
            {adminView === "admin" ? (
              <select
                value={o.status}
                onChange={(e) => handleStatusChange(o._id, e.target.value)}
                style={styles.select}
              >
                <option value="pending">Pending</option>
                <option value="processing">Processing</option>
                <option value="completed">Completed</option>
              </select>
            ) : (
              o.status
            )}
          </p>

          {adminView === "admin" && (
            <button onClick={() => handleDelete(o._id)} style={styles.deleteBtn}>
              ❌ Delete Order
            </button>
          )}
        </div>
      ))}

      {/* Pagination */}
      <div style={styles.pagination}>
        {Array.from({ length: totalPages }, (_, i) => (
          <button
            key={i}
            style={{
              ...styles.pageBtn,
              ...(currentPage === i + 1 ? styles.activePage : {}),
            }}
            onClick={() => setCurrentPage(i + 1)}
          >
            {i + 1}
          </button>
        ))}
      </div>
    </div>
  );
};

const styles = {
  container: {
    padding: 20,
    background: "#f9f9f9",
    fontFamily: "Arial",
    minHeight: "100vh",
  },
  banner: {
    width: "100%",
    borderRadius: 10,
    marginBottom: 20,
    maxHeight: 300,
    objectFit: "cover",
  },
  heading: {
    fontSize: 26,
    color: "#d63384",
    marginBottom: 20,
    textAlign: "center",
  },
  filters: {
    display: "flex",
    flexWrap: "wrap",
    gap: 10,
    marginBottom: 20,
  },
  input: {
    padding: 8,
    borderRadius: 6,
    border: "1px solid #ccc",
    flexGrow: 1,
    minWidth: 180,
  },
  select: {
    padding: 8,
    borderRadius: 6,
    border: "1px solid #ccc",
    minWidth: 140,
  },
  card: {
    background: "#fff",
    border: "1px solid #ddd",
    borderRadius: 10,
    padding: 15,
    marginBottom: 20,
    boxShadow: "0 3px 8px rgba(0,0,0,0.08)",
  },
  image: {
    width: 120,
    height: 120,
    objectFit: "cover",
    borderRadius: 6,
    marginBottom: 10,
  },
  deleteBtn: {
    background: "#dc3545",
    color: "#fff",
    padding: "8px 12px",
    border: "none",
    borderRadius: 6,
    marginTop: 10,
    cursor: "pointer",
  },
  pagination: {
    display: "flex",
    justifyContent: "center",
    marginTop: 20,
    gap: 6,
  },
  pageBtn: {
    padding: "6px 12px",
    borderRadius: 4,
    border: "1px solid #ccc",
    background: "#eee",
    cursor: "pointer",
  },
  activePage: {
    background: "#d63384",
    color: "#fff",
    fontWeight: "bold",
    border: "1px solid #d63384",
  },
};

export default Orders;
