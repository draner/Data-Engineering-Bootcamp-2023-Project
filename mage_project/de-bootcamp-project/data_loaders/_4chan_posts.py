import pandas as pd
import basc_py4chan

if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@data_loader
def load_data(*args, **kwargs):
    """
    Template code for loading data from any source.

    Returns:
        Anything (e.g. data frame, dictionary, array, int, str, etc.)
    """
    # First, we need to create a board object. This is the object that will be used to access the board.
    board = basc_py4chan.Board('pol')

    # Now we can retrieve all the threads on the board.
    threads = board.get_all_threads(expand=False)
    threads_ids = board.get_all_thread_ids()

    posts_df = pd.DataFrame()

    for i, thread in enumerate(threads):
        for post in thread.all_posts:
            post_dict = {'thread_id': threads_ids[i],
                        'post_id': post.post_id,
                        'poster_id': post.poster_id,
                        'poster_name': post.name,
                        'is_op': post.is_op,
                        'tripcode': post.tripcode,
                        'email': post.email,
                        'subject': post.subject,
                        'comment': post.text_comment,
                        'has_file': post.has_file,
                        'post_datetime': post.datetime,
                        'url': post.url}
            if post_dict['has_file']:
               post_dict['file_name'] = post.file.filename_original
               post_dict['file_extension'] = post.file.file_extension
            else:
                post_dict['file_name'] = None
                post_dict['file_extension'] = None

            new_row = pd.DataFrame(post_dict, index=[i])
            posts_df = pd.concat([posts_df, new_row], axis=0)
        print(f'done thread {i+1} of {len(threads_ids)}')

    return posts_df
