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

  return (
    <div className="text-center max-w-4xl">
      <div className="accent-bar mx-auto mb-8" />
      <p className="text-3xl md:text-5xl lg:text-6xl font-bold leading-tight shimmer-text">
        &bdquo;{visible}&ldquo;
        <span className={`typewriter-cursor${done ? " blinking" : ""}`}>|</span>
      </p>
      <div className="accent-bar mx-auto mt-8" />
    </div>
  );
}
