import axios, { AxiosResponse } from "axios";

axios.defaults.baseURL = 'api/';
const responseBody = (response: AxiosResponse) => response.data;

const requests = {
  get: (url: string) => axios.get(url).then(responseBody),
  post: (url: string, body: {}) => axios.post(url, body).then(responseBody),
  put: (url: string, body: {}) => axios.put(url, body).then(responseBody),
  delete: (url: string) => axios.delete(url).then(responseBody),
  postForm: (url: string, data: FormData) => axios.post(url, data, {
      headers: {'Content-type': 'multipart/form-data'}
  }).then(responseBody),
  putForm: (url: string, data: FormData) => axios.put(url, data, {
      headers: {'Content-type': 'multipart/form-data'}
  }).then(responseBody)
}

function createFormData(item: any) {
  let formData = new FormData();
  for (const key in item) {
      formData.append(key, item[key])
  }
  return formData;
}

const Orders = {
  getAll: () => requests.get('Order'),
  create: (order) => requests.postForm('Order', createFormData(order)),
  update: (order) => requests.putForm('Order', createFormData(order)),
  delete: (id: number) => requests.delete(`Order/${id}`),
};

const OrderItems = {
  getAll: () => requests.get('OrderItem'),
  getByOrderId: (orderId: number) => requests.get(`OrderItem/order-items/${orderId}`),
  create: (orderItem) => requests.postForm('OrderItem', createFormData(orderItem)),
  update: (orderItem) => requests.putForm('OrderItem', createFormData(orderItem)),
  delete: (id: number) => requests.delete(`OrderItem/${id}`)
}

const Users = {
  getAll: () => requests.get('User'),
  create: (user) => requests.postForm('User', createFormData(user)),
  update: (user) => requests.putForm('User', createFormData(user)),
  delete: (id: number) => requests.delete(`User/${id}`)
}

const Statistics = {
  getWashingUsers: () => {
    console.log('Calling statistics endpoint');
    return requests.get('statistics/washing-users')
        .then(response => {
            console.log('Statistics response:', response);
            return response;
        })
        .catch(error => {
            console.error('Statistics error:', error.response?.status, error.response?.data);
            throw error;
        });
},
  getCustomersWithHighestOrder: () => requests.get('statistics/customers-highest-order'),
  getUsersWithMultipleOrders: () => requests.get('statistics/users-multiple-orders'),
};

const agent = {
  Orders,
  OrderItems,
  Users,
  Statistics
};

export default agent;