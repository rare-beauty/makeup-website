import React, { useEffect, useState } from "react";
import Slider from "react-slick";
import { useNavigate } from "react-router-dom";
import "./DealsSlider.css"; // ✅ Make sure this CSS file exists

const DealsSlider = () => {
  const [deals, setDeals] = useState([]);
  const navigate = useNavigate();

  useEffect(() => {
    fetch("/api/products")
      .then((res) => res.json())
      .then((data) => {
        // ✅ Show only products that have images
        setDeals(data.filter((item) => item.imageUrl));
      })
      .catch((err) => console.error("❌ Failed to fetch deals", err));
  }, []);

  const settings = {
    infinite: true,
    speed: 600,
    slidesToShow: 3,
    slidesToScroll: 1,
    centerMode: true,
    autoplay: true,
    autoplaySpeed: 3000,
    focusOnSelect: true,
  };

  return (
    <div className="deals-slider">
      <h2 className="slider-heading">✨ Trending Products ✨</h2>
      <Slider {...settings}>
        {deals.map((deal, index) => (
          <div
            key={index}
            className="deal-card"
            onClick={() => navigate("/products")}
          >
            <img
              src={
                deal.imageUrl
                  ? `/api/products${deal.imageUrl}`
                  : "/assets/default-placeholder.png"
              }
              alt={deal.name}
              className="deal-image"
            />
            <h3 className="deal-title">{deal.name}</h3>
          </div>
        ))}
      </Slider>
    </div>
  );
};

export default DealsSlider;
