from fastapi import FastAPI, Request
from pydantic import BaseModel
from typing import List, Optional
import random

app = FastAPI(title="TalentForge AI Engine", version="1.0.0")

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

# --- Routes ---

@app.get("/")
def health_check():
    return {"status": "online", "service": "AI Engine"}

@app.post("/predict/anomaly")
def predict_anomaly(request: AnomalyRequest):
    """
    Detects anomalies in attendance patterns using Isolation Forest (Mocked).
    Real implementation would load 'model.pkl'.
    """
    # Mock Logic:
    # In a real scenario, we would preprocess 'records', fetch user history from MongoDB,
    # and pass it to the loaded sklearn model.
    
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

@app.post("/predict/performance")
def predict_performance(request: PerformanceRequest):
    """
    Predicts employee performance score (0-100).
    """
    # Mock Logic
    base_score = 70
    boost = min(request.tasks_completed * 2, 20)
    score = base_score + boost - (request.average_time / 10)
    
    return {
        "user_id": request.user_id,
        "predicted_score": round(max(0, min(100, score)), 1),
        "risk_level": "low" if score > 50 else "high"
    }
