part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}
