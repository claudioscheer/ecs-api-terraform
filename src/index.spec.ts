import request from "supertest";
import server from "./index";

afterAll(() => {
  server.close();
});

describe("index.ts", () => {
  describe("GET /_health", () => {
    it("should return status 200", async () => {
      const res = await request(server).get("/_health");
      expect(res.status).toEqual(200);
      expect(res.body).toEqual({ status: "healthy" });
    });
  });

  describe("GET /", () => {
    it("should return status 200", async () => {
      const res = await request(server).get("/");
      expect(res.status).toEqual(200);
      expect(res.body).toEqual({ message: "Hello World!" });
    });
  });
});
