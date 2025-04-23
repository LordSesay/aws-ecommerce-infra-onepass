// API wrapper with JWT injection
const BASE_URLS = {
    checkout: "https://<your-checkout-endpoint>/checkout",
    contact: "https://<your-contact-endpoint>/contact",
    feedback: "https://<your-feedback-endpoint>/feedback"
  };
  
  // TEMP hardcoded JWT (later pull from login/localStorage)
  const TOKEN = "Bearer YOUR_JWT_TOKEN_HERE";
  
  async function postData(endpoint, payload) {
    try {
      const res = await fetch(BASE_URLS[endpoint], {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": TOKEN
        },
        body: JSON.stringify(payload)
      });
  
      const data = await res.json();
      if (!res.ok) throw new Error(data.error || "Something went wrong");
  
      alert("✅ Success: " + (data.message || "Submitted successfully"));
      return data;
    } catch (err) {
      alert("❌ Error: " + err.message);
    }
  }
  