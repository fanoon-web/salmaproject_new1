abstract class UseCase<Type,Params> {
  
  Future<Type> call({Params params});
}

// تعريف NoParams
class NoParams {}