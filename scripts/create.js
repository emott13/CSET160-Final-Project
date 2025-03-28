if (document.readyState == 'DOMContentLoaded'){
    console.log('loaded')
    let nums = document.getElementById('questionNum');
    nums.addEventListener('change', createQuestions);

    function createQuestions(){
        console.log('hello')
    };
}