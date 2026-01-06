from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(
    title="TalentForge AI Engine",
    description="Internal Microservice for Anomaly Detection (Isolation Forest), HR Chatbot (LangChain), and Predictions",
    version="1.0.0"
)

# CORS - Allow requests strictly from internal services (mostly .NET in production)
# For dev, we might allow *
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"status": "online", "service": "TalentForge AI Engine", "role": "internal_only"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}
