import { Injectable } from '@nestjs/common';
import * as nodemailer from 'nodemailer'

@Injectable()
export class NodemailerService {
     public transporter = nodemailer.createTransport({
        host: 'smtp.gmail.com',
        port: 587,
        secure: false, // Use true for port 465, false for port 587
        auth: {
            user: "sanketinamdar72@gmail.com",
            pass: "ewlb ywqi pbmh jnnf",
        },
    });

    async sendVerificationEmail(to: string, Token: string) {
        try {
            const email_Url = `http://localhost:5173/auth?Token=${Token}`;

            const res = await this.transporter.sendMail({
                from: `"sanket send email to" <sanketinamdar72@gmail.com>`,
                to: to,
                subject: "Super Admin Verification Email",
                text: "this is verification email",
                html: `
                        <!DOCTYPE html>
                        <html>
                        <head>
                        <meta charset="UTF-8" />
                        <title>Super Admin Email Verification</title>
                        </head>
                        <body style="margin:0; padding:0; background-color:#f2f9ff; font-family:Arial, sans-serif;">
                        <table align="center" width="100%" cellpadding="0" cellspacing="0" style="max-width:600px; margin:40px auto; background:#ffffff; border-radius:8px; overflow:hidden; box-shadow:0 4px 10px rgba(0,0,0,0.05);">
                            
                            <!-- Header -->
                            <tr>
                            <td style="background:linear-gradient(90deg,#00b4db,#0083b0); padding:25px; text-align:center;">
                                <h1 style="color:#ffffff; margin:0; font-size:24px;">Email Verification</h1>
                            </td>
                            </tr>

                            <!-- Body -->
                            <tr>
                            <td style="padding:30px; color:#333333; font-size:16px; line-height:1.6;">
                                <p style="margin-top:0;">Hello,</p>

                                <p>
                                 Please confirm your email address by clicking the button below.
                                </p>

                                <div style="text-align:center; margin:30px 0;">
                                <a href="${email_Url}" 
                                    style="background-color:#00b4db; color:#ffffff; text-decoration:none; padding:12px 25px; border-radius:5px; font-weight:bold; display:inline-block;">
                                    Verify
                                </a>
                                </div>

                                <p>
                                If you did not request for verification, you can safely ignore it.
                                </p>

                                <p style="margin-bottom:0;">
                                Regards,<br/>
                                <strong>Dart Team</strong>
                                </p>
                            </td>
                            </tr>

                            <!-- Footer -->
                            <tr>
                            <td style="background-color:#f2f9ff; padding:15px; text-align:center; font-size:12px; color:#777;">
                                © ${new Date().getFullYear()} Your Company. All rights reserved.
                            </td>
                            </tr>

                        </table>
                        </body>
                        </html>
                        `
            });
           
            if(res.accepted){
                return res.accepted;
            }
        } catch (error) {
            console.log(error);
        }
    }
}
