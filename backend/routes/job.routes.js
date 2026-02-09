import express from "express";
import isAuth from "../middlewares/isAuth.js";
import { createJob, getAllJobs, getMyJobs, updateJob } from "../controllers/job.controllers.js";

const jobRouter = express.Router();

jobRouter.post("/create", isAuth, createJob);
jobRouter.get("/all", isAuth, getAllJobs);
jobRouter.get("/myjobs", isAuth, getMyJobs);
jobRouter.put("/update/:id", isAuth, updateJob);

export default jobRouter;
