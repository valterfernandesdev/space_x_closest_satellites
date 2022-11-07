import React, { useEffect, useState, useRef } from "react";
import Globe from 'react-globe.gl';
import axios from 'axios';

const API_URL = 'http://localhost:3000/satellites?number_of_satellites=20&latitude=-22.908333&longitude=-43.196388';

function getAPIData() {
  return axios.get(API_URL)
    .then((response) => response.data);
}

export default function App() {
  const globeEl = useRef();
  const [satellites, setSatellites] = useState([]);
  const MAP_CENTER = { lat: -22.908333, lng: -43.196388, altitude: 1 };
  
  useEffect(() => {
    let mounted = true;
    getAPIData().then((items) => {
      if(mounted) {
        setSatellites(items);
      }
    });
    globeEl.current.pointOfView(MAP_CENTER, 4000);
    return () => (mounted = false);
  }, []);

  const markerSvg = `<svg viewBox="-4 0 36 36">
    <path fill="currentColor" d="M14,0 C21.732,0 28,5.641 28,12.6 C28,23.963 14,36 14,36 C14,36 0,24.064 0,12.6 C0,5.641 6.268,0 14,0 Z"></path>
    <circle fill="black" cx="14" cy="14" r="7"></circle>
  </svg>`;

  const gData = satellites.map((satellite) => ({
    lat: satellite.latitude,
    lng: satellite.longitude,
    size: 25,
    color: 'blue',
  }));

  gData.push({
    lat: -22.908333,
    lng: -43.196388,
    size: 40,
    color: 'red',
  });

  return (
    <Globe
      ref={globeEl}
      globeImageUrl="//unpkg.com/three-globe/example/img/earth-day.jpg"
      htmlElementsData={gData}
      htmlElement={d => {
        const el = document.createElement('div');
        el.innerHTML = markerSvg;
        el.style.color = d.color;
        el.style.width = `${d.size}px`;
        el.style['pointer-events'] = 'auto';
        el.style.cursor = 'pointer';
        el.onmouseenter = () => alert('Latitude: ' + d.lat + ' Longitude: ' + d.lng);
        return el;
      }}
    />
  )
}
  