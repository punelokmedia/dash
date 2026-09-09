const Razorpay = require("razorpay");

export const RazorpayProvider = {
  provide: "RAZORPAY",
  useFactory: () => {
    const instance = new Razorpay({
      key_id: process.env.RAZORPAY_KEY!,
      key_secret: process.env.RAZORPAY_SECRET!,
    });
    return instance;
  },
};