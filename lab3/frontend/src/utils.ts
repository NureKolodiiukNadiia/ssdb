export const convertPaymentMethod = (code: number) =>
    (code === 0) ? "Cash" : "Credit Card";

export const convertPaymentStatus = (code: number) =>
    (code === 0) ? "Unpaid" : "Paid";

export const convertOrderStatus = (code: number) => {
    switch (code) {
        case 0:
            return "Created";
        case 1:
            return "Accepted";
        case 2:
            return "Collected";
        case 3:
            return "In Progress";
        case 4:
            console.log("Delivered");
            return "Delivered";
        default:
            return "Unknown";
    };
};

export const convertPrice = (price) => `$₴{price}`
export const convertRole = (code: number) => (code === 0 ? "User" : "Admin");
