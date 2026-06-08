"use client";

import { useEffect, useState } from "react";

export default function TypewriterQuote({ text }: { text: string }) {
  const [count, setCount] = useState(0);
  const done = count >= text.length;

  useEffect(() => {
    if (done) return;
    const timer = setTimeout(() => setCount((c) => c + 1), 70);
    return () => clearTimeout(timer);
  }, [count, done]);

  const visible = text.slice(0, count);
  const typed = visible.toLowerCase();

  // Jede Wortgruppe loest beim Tippen ihre eigene Animation aus
  const diving = typed.includes("tauchen");
  const traveling = typed.includes("reisen");
  const curious = typed.includes("bleiben");

  return (
    <>
      {diving && (
        <span className="motto-anim diver" aria-hidden>
          🤿
        </span>
      )}
      {traveling && (
        <span className="motto-anim plane" aria-hidden>
          ✈️
        </span>
      )}
      {curious && (
        <span className="motto-anim compass" aria-hidden>
          🧭
        </span>
      )}

      <div className="text-center max-w-4xl">
        <div className="accent-bar mx-auto mb-8" />
        <p className="text-3xl md:text-5xl lg:text-6xl font-bold leading-tight shimmer-text">
          &bdquo;{visible}&ldquo;
          <span className={`typewriter-cursor${done ? " blinking" : ""}`}>|</span>
        </p>
        <div className="accent-bar mx-auto mt-8" />
      </div>
    </>
  );
}
