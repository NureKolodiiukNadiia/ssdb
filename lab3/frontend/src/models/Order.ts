import {User} from "./User.ts";

export interface Order {
    id: number;
    status: OrderStatus;
    subtotal: number;
    description: string;
    paymentMehod: PaymentMethod;
    paymentStatus: PaymentStatus;
    deliveryFee: number;
    collectedDate: string;
    deliveredDate: string;
    user: User;
}

export enum PaymentMethod {
    Cash,
    CreditCard,
}

export enum PaymentStatus {
    Unpaid,
    Paid,
}

export enum OrderStatus {
    Created,
    Accepted,
    Collected,
    InProgress,
    Delivered,
}