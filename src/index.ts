import express, { Request, Response } from "express";

const app = express();
const port = 3000;

app.get("/_health", (_req: Request, res: Response) => {
  res.header("Content-Type", "application/json");
  res.status(200).send({ status: "healthy" });
});

app.get("/", (_req: Request, res: Response) => {
  res.header("Content-Type", "application/json");
  res.status(200).send({ message: "Hello World!" });
});

const server = app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

export default server;
