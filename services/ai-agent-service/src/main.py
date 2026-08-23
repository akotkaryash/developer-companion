from fastapi import FastAPI

app = FastAPI(title="Developer Companion AI Agent")

@app.get("/health")
def health_check():
    return {"status": "healthy", "service": "ai-agent"}