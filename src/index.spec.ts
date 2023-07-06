import { helloWorld } from "./index";

describe("helloWorld", () => {
  it("should say hello world", () => {
    const spy = jest.spyOn(console, "log");
    helloWorld();
    expect(spy).toHaveBeenCalledWith("Hello World!");
  });
});
