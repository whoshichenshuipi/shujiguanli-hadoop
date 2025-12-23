import request from './request';

export const listBooks = (params) => request.get('/books', { params });
export const saveBook = (data) => request.post('/books', data);
export const updateBook = (id, data) => request.put(`/books/${id}`, data);
export const deleteBook = (id) => request.delete(`/books/${id}`);

export const listReaders = (params) => request.get('/readers', { params });
export const saveReader = (data) => request.post('/readers', data);
export const updateReader = (id, data) => request.put(`/readers/${id}`, data);
export const deleteReader = (id) => request.delete(`/readers/${id}`);

export const listBorrow = () => request.get('/borrow');
export const borrowBook = (data) => request.post('/borrow', data);
export const returnBook = (id) => request.post(`/borrow/return/${id}`);

export const statHotBooks = (params) => request.get('/stat/hot-books', { params });
export const statBorrowTrend = (params) => request.get('/stat/borrow-trend', { params });
export const statReaderBehavior = (params) => request.get('/stat/reader-behavior', { params });

