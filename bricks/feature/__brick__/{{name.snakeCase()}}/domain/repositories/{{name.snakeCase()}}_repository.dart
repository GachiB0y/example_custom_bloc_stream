abstract interface class I{{name.pascalCase()}}Repository{

}

class {{name.pascalCase()}}RepositoryImpl implements I{{name.pascalCase()}}Repository {

   const {{name.pascalCase()}}RepositoryImpl({
   required I{{name.pascalCase()}}Api api,
    required {{name.pascalCase()}}Mapper mapper,
  })  : api = api,
        mapper = mapper;
  final I{{name.pascalCase()}}Api api;
  final {{name.pascalCase()}}Mapper mapper;
}