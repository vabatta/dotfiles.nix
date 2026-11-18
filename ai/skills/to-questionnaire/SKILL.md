---
name: to-questionnaire
description: "Turns a decision the user cannot answer alone into a fillable questionnaire for the person who holds the knowledge. Use when the missing information lives with another human rather than in the code, history, or sources, such as when asked to prepare questions for the PM, legal, a client, or another team, or to send a stakeholder what we need from them."
---

# To questionnaire

Turn something the user cannot answer alone into a questionnaire, a Markdown document handed to one person, filled async or in a meeting. The recipient holds knowledge the user lacks.

## Grill the send, not the subject

Interview the user only about the send, meaning who it goes to and what they need back. Questions target the gap between the recipient's knowledge and the user's need. For knowledge that lives in code or history instead, use **why** or **how**.

## Steps

Skip a step whose answer the request already gives. When no human can answer, record the recommended answer as an assumption in the questionnaire and continue.

1. Who is it going to, and who is it from? One exchange. Recipient role, expertise, relationship, and the sender's name. Done when you know who and what they know that the user does not.
2. What do you need back, and by when? One exchange. The decisions or facts the user cannot resolve alone, and the deadline. Done when you have a concrete list of what the user must be able to do or decide, plus a deadline or "no deadline".
3. Write the questionnaire. Draft questions at the gap, fill in [assets/questionnaire.md](assets/questionnaire.md), and give it in the reply as one copyable block. Do not send it. The user hands it over. Done when every step-2 item is covered and the reply holds the questionnaire.

## Document structure

Put the most important questions first, since async recipients answer in one pass. Group under `##` theme headings once there are more than 5 questions. Keep each question to one idea, never compound.

For the interview that settles the subject itself, before it is written down, use **grill**.
