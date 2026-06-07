const https = require("https");

function httpsPost(options, bodyStr) {
  return new Promise((resolve, reject) => {
    const req = https.request(options, (res) => {
      let data = "";
      res.on("data", chunk => data += chunk);
      res.on("end", () => resolve({ status: res.statusCode, body: data }));
    });
    req.on("error", reject);
    req.write(bodyStr);
    req.end();
  });
}

exports.handler = async function(event) {
  if (event.httpMethod === "OPTIONS") return { statusCode: 200, body: "" };
  if (event.httpMethod !== "POST") return { statusCode: 405, body: "Method not allowed" };
  const apiKey = process.env.ANTHROPIC_API_KEY;
  if (!apiKey) return { statusCode: 500, body: JSON.stringify({ error: { message: "API key not configured." } }) };
  try {
    const body = JSON.parse(event.body);
    const payload = JSON.stringify({
      model: "claude-sonnet-4-5",
      max_tokens: body.max_tokens || 1500,
      system: body.system,
      messages: body.messages
    });
    const result = await httpsPost({
      hostname: "api.anthropic.com",
      path: "/v1/messages",
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Content-Length": Buffer.byteLength(payload),
        "x-api-key": apiKey,
        "anthropic-version": "2023-06-01"
      }
    }, payload);
    return {
      statusCode: result.status,
      headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" },
      body: result.body
    };
  } catch (err) {
    return { statusCode: 500, headers: { "Content-Type": "application/json" }, body: JSON.stringify({ error: { message: "Proxy error: " + err.message } }) };
  }
};
