import { Navbar } from "@/components/layout/Navbar";
import { Footer } from "@/components/layout/Footer";
import { Hero } from "@/components/sections/Hero";
import { Stats } from "@/components/sections/Stats";
import { About } from "@/components/sections/About";
import { Roadmap } from "@/components/sections/Roadmap";
import { AppShowcase } from "@/components/sections/AppShowcase";
import { Partners } from "@/components/sections/Partners";
import { Contact } from "@/components/sections/Contact";

export default function Home() {
  return (
    <main className="min-h-screen bg-white">
      <Navbar />
      <Hero />
      <Stats />
      <About />
      <Roadmap />
      <AppShowcase />
      <Partners />
      <Contact />
      <Footer />
    </main>
  );
}
