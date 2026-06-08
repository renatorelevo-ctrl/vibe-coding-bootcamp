import Welcome from "@/components/Welcome";
import TypewriterQuote from "@/components/TypewriterQuote";
import BootcampFooter from "@/components/BootcampFooter";

export default function Home() {
  const motto = process.env.NEXT_PUBLIC_MOTTO;

  return (
    <main className="min-h-screen flex flex-col">
      <div className="flex-1 flex items-center justify-center px-6">
        {motto ? <TypewriterQuote text={motto} /> : <Welcome />}
      </div>

      <BootcampFooter />
    </main>
  );
}
