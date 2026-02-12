import { Router } from 'express';
import { getAllUsers, getUserById, createUser, updateUser, deleteUser } from '../controllers/user.controller';
import { authenticate, authorize } from '../middlewares/auth.middleware';
import { auditLog } from '../middlewares/audit.middleware';

const router = Router();

router.use(authenticate);

router.get('/', authorize(['ADMIN']), getAllUsers);
router.get('/:id', authorize(['ADMIN']), getUserById);
router.post('/', authorize(['ADMIN']), auditLog('CREATE_USER', 'USER'), createUser);
router.put('/:id', authorize(['ADMIN']), auditLog('UPDATE_USER', 'USER'), updateUser);
router.delete('/:id', authorize(['ADMIN']), auditLog('DELETE_USER', 'USER'), deleteUser);

export default router;
