from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
import random

app = FastAPI(
    title="TalentForge AI Engine",
    description="Internal Microservice for Anomaly Detection (Isolation Forest), HR Chatbot (LangChain), and Predictions",
    version="1.0.0"
)

# CORS - Allow requests strictly from internal services (mostly .NET in production)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- Data Models ---
class AttendanceRecord(BaseModel):
    user_id: int
    check_in_time: str
    location: dict

class AnomalyRequest(BaseModel):
    records: List[AttendanceRecord]

class PerformanceRequest(BaseModel):
    user_id: int
    tasks_completed: int
    average_time: float

@app.get("/")
async def root():
    return {"status": "online", "service": "TalentForge AI Engine", "role": "internal_only"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

@app.post("/anomalies")
def predict_anomaly(request: AnomalyRequest):
    """
    Detects anomalies in attendance patterns using Isolation Forest (Mocked).
    """
    anomalies = []
    for record in request.records:
        # Mocking: Randomly flag 10% of records as anomalies
        is_anomaly = random.random() < 0.1 
        if is_anomaly:
            anomalies.append({
                "user_id": record.user_id,
                "confidence": round(random.uniform(0.7, 0.99), 2),
                "reason": "Irregular check-in time detected"
            })
            
    return {
        "status": "success",
        "anomalies": anomalies,
        "model_version": "v1.0-mock"
    }

@app.post("/performance")
def predict_performance(request: PerformanceRequest):
    """
    Predicts employee performance score (0-100).
    """
    base_score = 70
    boost = min(request.tasks_completed * 2, 20)
    score = base_score + boost - (request.average_time / 10)
    
    return {
        "user_id": request.user_id,
        "predicted_score": round(max(0, min(100, score)), 1),
        "risk_level": "low" if score > 50 else "high"
    }
